{
  lib,
  stdenv,
  fetchFromGitHub,
  cudd,
  gmp,
  gperf,
  autoreconfHook,
  libpoly,
  ncurses5,
}:

let
  gmp-static = gmp.override { withStatic = true; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "yices";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "yices2";
    tag = "yices-${finalAttrs.version}";
    hash = "sha256-HEsLe/7tXzidBx/1Dfj6uZbu6jZWO7RMB26oMA19iuI=";
  };

  postPatch = ''
    patchShebangs tests/regress/check.sh
  ''
  # operation not permitted
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace utils/make_source_version \
      --replace-fail '"/usr/bin/mktemp -t out"' "mktemp"
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    cudd
    gmp-static
    gperf
    libpoly
  ];
  configureFlags = [
    "--with-static-gmp=${gmp-static.out}/lib/libgmp.a"
    "--with-static-gmp-include-dir=${gmp-static.dev}/include"
    "--enable-mcsat"
  ];

  enableParallelBuilding = true;
  doCheck = true;

  nativeCheckInputs = [ ncurses5 ];

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage = "https://yices.csl.sri.com";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
})
