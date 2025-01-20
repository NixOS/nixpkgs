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
      in
      lib.recursiveUpdateUntil stopPred prevAttrs.passthru {
        tests.get-version-and-variant = prevAttrs.passthru.tests.get-version-and-variant.override {
          variant = "cs";
        };
      };
  }
)
