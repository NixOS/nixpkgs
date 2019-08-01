{ stdenv
, callPackage
, fetchgit
, ghcjsSrcJson ? null
, ghcjsSrc ? fetchgit (builtins.fromJSON (builtins.readFile ghcjsSrcJson))
, bootPkgs
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
, haskell
}:

let
  passthru = {
    configuredSrc = callPackage ./configured-ghcjs-src.nix {
      inherit ghcjsSrc;
      inherit (bootPkgs) ghc alex happy;
    };
    genStage0 = callPackage ./mk-stage0.nix { inherit (passthru) configuredSrc; };
    bootPkgs = bootPkgs.extend (lib.foldr lib.composeExtensions (_:_:{}) [
      (self: _: import stage0 {
        inherit (passthru) configuredSrc;
        inherit (self) callPackage;
      })

      (callPackage ./common-overrides.nix {
        inherit haskellLib;
        inherit (bootPkgs) alex happy;
      })
      ghcjsDepOverrides
    ]);

    targetPrefix = "";
    inherit bootGhcjs;
    inherit (bootGhcjs) version;
    ghcVersion = bootPkgs.ghc.version;
    isGhcjs = true;

    enableShared = true;

    socket-io = nodePackages."socket.io";

    # Relics of the old GHCJS build system
    stage1Packages = [];
    mkStage2 = { callPackage }: {
      # https://github.com/ghcjs/ghcjs-base/issues/110
      # https://github.com/ghcjs/ghcjs-base/pull/111
      ghcjs-base = haskell.lib.dontCheck (haskell.lib.doJailbreak (callPackage ./ghcjs-base.nix {}));
    };

    haskellCompilerName = "ghcjs-${bootGhcjs.version}";
  };

  bootGhcjs = haskellLib.justStaticExecutables passthru.bootPkgs.ghcjs;
  libexec = "${bootGhcjs}/libexec/${builtins.replaceStrings ["darwin" "i686"] ["osx" "i386"] stdenv.buildPlatform.system}-${passthru.bootPkgs.ghc.name}/${bootGhcjs.name}";

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
    dontConfigure = true;
    dontInstall = true;
    buildPhase = ''
      export HOME=$TMP
      mkdir $HOME/.cabal
      touch $HOME/.cabal/config
      cd lib/boot

      mkdir -p $out/bin
      mkdir -p $out/lib/${bootGhcjs.name}
      lndir ${libexec} $out/bin

      wrapProgram $out/bin/ghcjs --add-flags "-B$out/lib/${bootGhcjs.name}"
      wrapProgram $out/bin/haddock-ghcjs --add-flags "-B$out/lib/${bootGhcjs.name}"
      wrapProgram $out/bin/ghcjs-pkg --add-flags "--global-package-db=$out/lib/${bootGhcjs.name}/package.conf.d"

      env PATH=$out/bin:$PATH $out/bin/ghcjs-boot -j1 --with-ghcjs-bin $out/bin
    '';

    # We hard code -j1 as a temporary workaround for
    # https://github.com/ghcjs/ghcjs/issues/654
    # enableParallelBuilding = true;

    inherit passthru;

    meta.platforms = passthru.bootPkgs.ghc.meta.platforms;
    meta.maintainers = [lib.maintainers.elvishjerricco];
  }
