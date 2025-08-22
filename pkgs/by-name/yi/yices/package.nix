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
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "yices2";
    tag = "yices-${finalAttrs.version}";
    hash = "sha256-siyepgxqKWRyO4+SB95lmhJ98iDubk0R0ErEJdSsM8o=";
  };

  postPatch = "patchShebangs tests/regress/check.sh";

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

  meta = with lib; {
    description = "High-performance theorem prover and SMT solver";
    homepage = "https://yices.csl.sri.com";
    license = licenses.gpl3;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ thoughtpolice ];
  };
})
