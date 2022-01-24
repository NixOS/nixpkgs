{ fetchurl, lib, stdenv, unzip, scheme, texinfo }:

stdenv.mkDerivation rec {
  pname = "slib";
  version = "3b5";

  src = fetchurl {
    url = "https://groups.csail.mit.edu/mac/ftpdir/scm/${pname}-${version}.zip";
    sha256 = "0q0p2d53p8qw2592yknzgy2y1p5a9k7ppjx0cfrbvk6242c4mdpq";
  };

  patches = [ ./catalog-in-library-vicinity.patch ];

  nativeBuildInputs = [ unzip ];
  buildInputs = [ scheme texinfo ];

  postInstall = ''
    ln -s mklibcat{.scm,}
    SCHEME_LIBRARY_PATH="$out/lib/slib" make catalogs

    sed -i "$out/bin/slib" \
        -e "/^SCHEME_LIBRARY_PATH/i export PATH=\"${scheme}/bin:\$PATH\""
  '';

  # There's no test suite (?!).
  doCheck = false;

  setupHook = ./setup-hook.sh;

  meta = {
    description = "The SLIB Portable Scheme Library";

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
