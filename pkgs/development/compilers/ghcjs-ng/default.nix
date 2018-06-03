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
, pkgconfig
, gcc
, lib
, nodePackages
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
    inherit bootGhcjs;
    inherit (bootGhcjs) version;
    isGhcjs = true;

    socket-io = nodePackages."socket.io";

    # Relics of the old GHCJS build system
    stage1Packages = [];
    mkStage2 = _: {};
  };

  bootGhcjs = haskellLib.justStaticExecutables passthru.bootPkgs.ghcjs;
  libexec = "${bootGhcjs}/libexec/${builtins.replaceStrings ["darwin"] ["osx"] stdenv.system}-${passthru.bootPkgs.ghc.name}/${bootGhcjs.name}";

in stdenv.mkDerivation {
    name = bootGhcjs.name;
    src = passthru.configuredSrc;
    nativeBuildInputs = [
      bootGhcjs
      passthru.bootPkgs.ghc
      cabal-install
      nodejs
      makeWrapper
      xorg.lndir
      gmp
      pkgconfig
    ] ++ lib.optionals stdenv.isDarwin [
      gcc # https://github.com/ghcjs/ghcjs/issues/663
    ];
    phases = ["unpackPhase" "buildPhase"];
    buildPhase = ''
      export HOME=$TMP
      mkdir $HOME/.cabal
      touch $HOME/.cabal/config
      cd lib/boot

      mkdir -p $out/bin
      mkdir -p $out/libexec
      lndir ${libexec} $out/bin

      wrapProgram $out/bin/ghcjs --add-flags "-B$out/libexec"
      wrapProgram $out/bin/haddock-ghcjs --add-flags "-B$out/libexec"
      wrapProgram $out/bin/ghcjs-pkg --add-flags "--global-package-db=$out/libexec/package.conf.d"

      env PATH=$out/bin:$PATH $out/bin/ghcjs-boot -j1 --with-ghcjs-bin $out/bin
    '';

    # We hard code -j1 as a temporary workaround for
    # https://github.com/ghcjs/ghcjs/issues/654
    # enableParallelBuilding = true;

    inherit passthru;

    meta.platforms = passthru.bootPkgs.ghc.meta.platforms;
  }

