{ fetchurl, stdenv, unzip, scheme, texinfo }:

stdenv.mkDerivation rec {
  name = "slib-3b2";

  src = fetchurl {
    url = "http://groups.csail.mit.edu/mac/ftpdir/scm/${name}.zip";
    sha256 = "1s6a7f3ha2bhwj4nkg34n0j511ww1nlgrn5xis8k53l8ghdrrjxi";
  };

  patches = [ ./catalog-in-library-vicinity.patch ];

  buildInputs = [ unzip scheme texinfo ];

  configurePhase = ''
    mkdir -p "$out"
    sed -i "Makefile" \
        -e "s|^[[:blank:]]*prefix[[:blank:]]*=.*$|prefix = $out/|g"
  '';

  buildPhase = "make infoz";

  installPhase = ''
    make install

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
    license = stdenv.lib.licenses.publicDomain;

    homepage = http://people.csail.mit.edu/jaffer/SLIB;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
