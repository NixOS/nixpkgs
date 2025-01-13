{
  lib,
  racket-minimal,
  racket-unstable-minimal-bc,

  libiconvReal,
  libz,
  lz4,
  ncurses,
  openssl,

  disableDocs ? false,

  newScope,
}:

let
  stable = racket-minimal.override { inherit disableDocs; };
  bc = racket-unstable-minimal-bc.override { inherit disableDocs; };
in

bc.overrideAttrs (
  finalAttrs: prevAttrs: {
    buildInputs = [
      libiconvReal
      libz
      lz4
      ncurses
      openssl
    ];

    configureFlags = stable.configureFlags ++ [
      "--enable-racket=${lib.getExe bc}"
    ];

    passthru =
      let
        notUpdated = x: !builtins.isAttrs x || lib.isDerivation x;
        stopPred =
          _: lhs: rhs:
          notUpdated lhs || notUpdated rhs;
        callWithRacket = newScope { racket = finalAttrs.finalPackage; };
      in
      lib.recursiveUpdateUntil stopPred prevAttrs.passthru {
        tests = {
          get-version-and-variant = prevAttrs.passthru.tests.get-version-and-variant.override {
            variant = "cs";
          };
          nix-make-package = callWithRacket ../tests/nix-make-package.nix { };
          nix-with-packages = callWithRacket ../tests/nix-with-packages.nix { };
        };
      };
  }
)
