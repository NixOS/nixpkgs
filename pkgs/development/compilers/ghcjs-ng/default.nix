{ stdenv
, callPackage
, fetchgit
, ghcjsSrcJson ? null
, ghcjsSrc ? fetchgit (builtins.fromJSON (builtins.readFile ghcjsSrcJson))
, bootPkgs
, alex
, happy
, stage0
, haskellLib
, cabal-install
, nodejs
, makeWrapper
, xorg
, gmp
, lib
, ghcjsDepOverrides ? (_:_:{})
}:

let
  passthru = {
    configuredSrc = callPackage ./configured-ghcjs-src.nix {
      inherit ghcjsSrc alex happy;
      inherit (bootPkgs) ghc;
    };
    genStage0 = callPackage ./mk-stage0.nix { inherit (passthru) configuredSrc; };
    bootPkgs = bootPkgs.extend (lib.foldr lib.composeExtensions (_:_:{}) [
      (self: _: import stage0 {
        inherit (passthru) configuredSrc;
        inherit (self) callPackage;
      })

      (callPackage ./common-overrides.nix { inherit haskellLib alex happy; })
      ghcjsDepOverrides
    ]);

    targetPrefix = "";
    inherit (passthru.bootPkgs.ghcjs) version;
    isGhcjs = true;

    # Relics of the old GHCJS build system
    stage1Packages = [];
    mkStage2 = _: {};
  };

  libexec =
    if builtins.compareVersions passthru.bootPkgs.ghcjs.version "8.3" <= 0
      then "${passthru.bootPkgs.ghcjs}/bin"
      else "${passthru.bootPkgs.ghcjs}/libexec/${stdenv.system}-${passthru.bootPkgs.ghc.name}/${passthru.bootPkgs.ghcjs.name}";

in stdenv.mkDerivation {
    name = "ghcjs";
    src = passthru.configuredSrc;
    nativeBuildInputs = [passthru.bootPkgs.ghcjs passthru.bootPkgs.ghc cabal-install nodejs makeWrapper xorg.lndir gmp];
    phases = ["unpackPhase" "buildPhase"];
    buildPhase = ''
      export HOME=$TMP
      cd lib/boot

      mkdir -p $out/bin
      mkdir -p $out/libexec
      lndir ${libexec} $out/bin

      wrapProgram $out/bin/ghcjs --add-flags "-B$out/libexec"
      wrapProgram $out/bin/haddock-ghcjs --add-flags "-B$out/libexec"
      wrapProgram $out/bin/ghcjs-pkg --add-flags "--global-package-db=$out/libexec/package.conf.d"

      env PATH=$out/bin:$PATH $out/bin/ghcjs-boot -j $NIX_BUILD_CORES --with-ghcjs-bin $out/bin
    '';

    enableParallelBuilding = true;

    inherit passthru;

    meta.platforms = passthru.bootPkgs.ghc.meta.platforms;
  }

