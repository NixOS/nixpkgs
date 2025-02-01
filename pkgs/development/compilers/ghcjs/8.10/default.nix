{
  stdenv,
  pkgsHostHost,
  callPackage,
  fetchgit,
  fetchpatch,
  ghcjsSrcJson ? null,
  ghcjsSrc ? fetchgit (lib.importJSON ghcjsSrcJson),
  bootPkgs,
  stage0,
  haskellLib,
  cabal-install,
  nodejs,
  makeWrapper,
  xorg,
  gmp,
  pkg-config,
  gcc,
  lib,
  ghcjsDepOverrides ? (_: _: { }),
  linkFarm,
  buildPackages,
}:

let
  passthru = {
    configuredSrc = callPackage ./configured-ghcjs-src.nix {
      inherit ghcjsSrc;
      inherit (bootPkgs) ghc alex;
      inherit (bootGhcjs) version;
      happy = bootPkgs.happy_1_19_12;
    };
    bootPkgs = bootPkgs.extend (
      lib.foldr lib.composeExtensions (_: _: { }) [
        (
          self: _:
          import stage0 {
            inherit (passthru) configuredSrc;
            inherit (self) callPackage;
          }
        )

        (callPackage ./common-overrides.nix {
          inherit haskellLib fetchpatch buildPackages;
        })
        ghcjsDepOverrides
      ]
    );

    targetPrefix = "";
    inherit bootGhcjs;
    inherit (bootGhcjs) version;
    isGhcjs = true;

    llvmPackages = null;
    enableShared = true;

    socket-io = pkgsHostHost.nodePackages."socket.io";

    haskellCompilerName = "ghcjs-${bootGhcjs.version}";
  };

  bootGhcjs = haskellLib.justStaticExecutables passthru.bootPkgs.ghcjs;

  # This provides the stuff we need from the emsdk
  emsdk = linkFarm "emsdk" [
    {
      name = "upstream/bin";
      path = buildPackages.clang + "/bin";
    }
    {
      name = "upstream/emscripten";
      path = buildPackages.emscripten + "/bin";
    }
  ];

in
stdenv.mkDerivation {
  name = bootGhcjs.name;
  src = passthru.configuredSrc;
  nativeBuildInputs =
    [
      bootGhcjs
      passthru.bootPkgs.ghc
      cabal-install
      nodejs
      makeWrapper
      xorg.lndir
      gmp
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      gcc # https://github.com/ghcjs/ghcjs/issues/663
    ];
  dontConfigure = true;
  dontInstall = true;

  # Newer versions of `config.sub` reject the `js-ghcjs` host string, but the
  # older `config.sub` filed vendored within `ghc` still works
  dontUpdateAutotoolsGnuConfigScripts = true;

  buildPhase = ''
    export HOME=$TMP
    mkdir $HOME/.cabal
    touch $HOME/.cabal/config
    cd lib/boot

    mkdir -p $out/bin
    mkdir -p $out/lib/${bootGhcjs.name}
    lndir ${bootGhcjs}/bin $out/bin
    chmod -R +w $out/bin
    rm $out/bin/ghcjs-boot
    cp ${bootGhcjs}/bin/ghcjs-boot $out/bin
    rm $out/bin/haddock
    cp ${bootGhcjs}/bin/haddock $out/bin
    cp ${bootGhcjs}/bin/private-ghcjs-hsc2hs $out/bin/ghcjs-hsc2hs

    wrapProgram $out/bin/ghcjs-boot --set ghcjs_libexecdir $out/bin

    wrapProgram $out/bin/ghcjs --add-flags "-B$out/lib/${bootGhcjs.name}"
    wrapProgram $out/bin/haddock --add-flags "-B$out/lib/${bootGhcjs.name}"
    wrapProgram $out/bin/ghcjs-pkg --add-flags "--global-package-db=$out/lib/${bootGhcjs.name}/package.conf.d"
    wrapProgram $out/bin/ghcjs-hsc2hs --add-flags "-I$out/lib/${bootGhcjs.name}/include --template=$out/lib/${bootGhcjs.name}/include/template-hsc.h"

    env PATH=$out/bin:$PATH $out/bin/ghcjs-boot --with-emsdk=${emsdk} --no-haddock
  '';

  enableParallelBuilding = true;

  inherit passthru;

  meta = {
    platforms = with lib.platforms; linux ++ darwin;

    # Hydra limits jobs to only outputting 1 gigabyte worth of files.
    # GHCJS outputs over 3 gigabytes.
    # https://github.com/NixOS/nixpkgs/pull/137066#issuecomment-922335563
    hydraPlatforms = lib.platforms.none;

    maintainers = with lib.maintainers; [ obsidian-systems-maintenance ];
  };
}
