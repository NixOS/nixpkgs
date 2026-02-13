{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  callPackage,
  pkg-config,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ucg";
  version = "unstable-2022-09-03";

  src = fetchFromGitHub {
    owner = "gvansickle";
    repo = "ucg";
    rev = "cbb185e8adad6546b7e1c5e9ca59a81f98dca49f";
    hash = "sha256-Osdyxp8DoEjcr2wQLCPqOQ2zQf/0JWYxaDpZB02ACWo=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    pcre2
  ];

  passthru.tests = {
    simple = callPackage ./tests/simple.nix {
      ucg = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://gvansickle.github.io/ucg/";
    description = "Grep-like tool for searching large bodies of source code";
    longDescription = ''
      UniversalCodeGrep (ucg) is an extremely fast grep-like tool specialized
      for searching large bodies of source code. It is intended to be largely
      command-line compatible with Ack, to some extent with ag, and where
      appropriate with grep. Search patterns are specified as PCRE regexes.
    '';
    license = lib.licenses.gpl3Plus;
    mainProgram = "ucg";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isDarwin;
  };
})
# TODO: report upstream
