{ lib, stdenv, fetchurl, scheme, texinfo, unzip }:

stdenv.mkDerivation rec {
  pname = "slib";
  version = "3c1";

  src = fetchurl {
    url = "https://groups.csail.mit.edu/mac/ftpdir/scm/${pname}-${version}.zip";
    hash = "sha256-wvjrmOYFMN9TIRmF1LQDtul6epaYM8Gm0b+DVh2gx4E=";
  };

  patches = [
    ./catalog-in-library-vicinity.patch
  ];

  # slib:require unsupported feature color-database
  postPatch = ''
    substituteInPlace Makefile \
      --replace " clrnamdb.scm" ""
  '';

  nativeBuildInputs = [ scheme texinfo unzip ];
  buildInputs = [ scheme ];

  postInstall = ''
    ln -s mklibcat{.scm,}
    SCHEME_LIBRARY_PATH="$out/lib/slib" make catalogs

    sed -i \
      -e '2i export PATH="${scheme}/bin:$PATH"' \
      -e '3i export GUILE_AUTO_COMPILE=0' \
      $out/bin/slib
  '';

  # There's no test suite (?!).
  doCheck = false;

  setupHook = ./setup-hook.sh;

  meta = {
    description = "SLIB Portable Scheme Library";
    mainProgram = "slib";

    longDescription = ''
      SLIB is a portable library for the programming language Scheme.  It
      provides a platform independent framework for using packages of Scheme
      procedures and syntax.  As distributed, SLIB contains useful packages
      for all Scheme implementations.  Its catalog can be transparently
      extended to accommodate packages specific to a site, implementation,
      user, or directory.

      SLIB supports Bigloo, Chez, ELK 3.0, Gambit 4.0, Guile, JScheme, Kawa,
      Larceny, MacScheme, MIT/GNU Scheme, Pocket Scheme, RScheme, scheme->C,
      Scheme48, SCM, SCM Mac, scsh, sisc, Stk, T3.1, umb-scheme, and VSCM.
    '';

    # Public domain + permissive (non-copyleft) licensing of some files.
    license = lib.licenses.publicDomain;

    homepage = "http://people.csail.mit.edu/jaffer/SLIB";

    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
