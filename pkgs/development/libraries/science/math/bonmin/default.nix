{ lib
, stdenv
, fetchFromGitHub
, fontconfig
, gfortran
, pkg-config
, blas
, bzip2
, cbc
, clp
, doxygen
, graphviz
, ipopt
, lapack
, libamplsolver
, osi
, texliveSmall
, zlib
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "bonmin";
  version = "1.8.9";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Bonmin";
    rev = "releases/${version}";
    sha256 = "sha256-nqjAQ1NdNJ/T4p8YljEWRt/uy2aDwyBeAsag0TmRc5Q=";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    doxygen
    gfortran
    graphviz
    pkg-config
    texliveSmall
  ];
  buildInputs = [
    blas
    bzip2
    cbc
    clp
    ipopt
    lapack
    libamplsolver
    osi
    zlib
  ];

  configureFlags = lib.optionals stdenv.isDarwin [
    "--with-asl-lib=-lipoptamplinterface -lamplsolver"
  ];

  # Fix doc install. Should not be necessary after next release
  # ref https://github.com/coin-or/Bonmin/commit/4f665bc9e489a73cb867472be9aea518976ecd28
  sourceRoot = "${src.name}/Bonmin";

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  # Fontconfig error: No writable cache directories
  preBuild = "export XDG_CACHE_HOME=$(mktemp -d)";

  doCheck = true;
  checkTarget = "test";

  # ignore one failing test
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace test/Makefile.in --replace-fail \
      "./unitTest\''$(EXEEXT)" \
      ""
  '';

  # install documentation
  postInstall = "make install-doxygen-docs";

  meta = {
    description = "Open-source code for solving general MINLP (Mixed Integer NonLinear Programming) problems";
    mainProgram = "bonmin";
    homepage = "https://github.com/coin-or/Bonmin";
    license = lib.licenses.epl10;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aanderse ];
  };
}
