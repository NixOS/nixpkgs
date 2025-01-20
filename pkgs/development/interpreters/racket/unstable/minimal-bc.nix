{
  lib,
  stdenv,
  fetchFromGitHub,
  racket-minimal,

  libffi,
  libiconvReal,
  ncurses,
  openssl,

  disableDocs ? false,

  nix-prefetch-github,
}:

let
  stable = racket-minimal.override { inherit disableDocs; };

  inherit (stdenv.hostPlatform) isDarwin isStatic;

  manifest = lib.importJSON ./manifest.json;
in

stable.overrideAttrs (
  finalAttrs: prevAttrs: {
    inherit (manifest) version;

    src = fetchFromGitHub manifest.args;

    buildInputs = [
      libffi
      libiconvReal
      ncurses
      openssl
    ];

    sourceRoot = lib.path.subpath.join [
      finalAttrs.src.name
      "racket/src"
    ];

    preConfigure = ''
      mkdir build
      cd build
    '';

    configureFlags =
      [
        "--enable-bconly"
      ]
      ++ lib.optional disableDocs "--disable-docs"
      ++ lib.optionals (!isStatic) [
        "--disable-libs"
        "--enable-shared"
      ]
      ++ lib.optionals isDarwin [
        "--disable-strip"
        "--enable-xonx"
      ];

    postFixup =
      let
        configureInstallation = builtins.path {
          name = "configure-installation.rkt";
          path = ./configure-installation.rkt;
        };

        installPackages = builtins.path {
          name = "install-packages.rkt";
          path = ./install-packages.rkt;
        };
      in
      ''
        $out/bin/racket -U -u ${configureInstallation}

        $out/bin/racket -U -u ${installPackages} ${manifest.args.rev}
      '';

    passthru =
      let
        notUpdated = x: !builtins.isAttrs x || lib.isDerivation x;
        stopPred =
          _: lhs: rhs:
          notUpdated lhs || notUpdated rhs;
      in
      lib.recursiveUpdateUntil stopPred prevAttrs.passthru {
        updateScript = {
          command = finalAttrs.passthru.writeScript "racket-unstable-update" {
            makeWrapperArgs = [
              "--prefix"
              "PATH"
              ":"
              (lib.makeBinPath [ nix-prefetch-github ])
            ];
          } (builtins.readFile ./update.rkt);
          supportedFeatures = [ "commit" ];
        };

        tests.get-version-and-variant = prevAttrs.passthru.tests.get-version-and-variant.override {
          version = builtins.elemAt (lib.splitString "-" finalAttrs.version) 0;
          variant = "3m";
        };
      };
  }
)
