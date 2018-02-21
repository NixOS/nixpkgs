{ buildPythonPackage
, fetchurl
, makeFontsConf
, freefont_ttf
, pytest
, glibcLocales
, cairo
, cffi
, withXcffib ? false, xcffib
, python
, fetchpatch
, glib
, gdk_pixbuf }:

buildPythonPackage rec {
  name = "cairocffi-0.7.2";

  src = fetchurl {
    url = "mirror://pypi/c/cairocffi/${name}.tar.gz";
    sha256 = "e42b4256d27bd960cbf3b91a6c55d602defcdbc2a73f7317849c80279feeb975";
  };

  LC_ALL = "en_US.UTF-8";

  # checkPhase require at least one 'normal' font and one 'monospace',
  # otherwise glyph tests fails
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  checkInputs = [ pytest glibcLocales ];
  propagatedBuildInputs = [ cairo cffi ] ++ lib.optional withXcffib xcffib;

  checkPhase = ''
    py.test $out/${python.sitePackages}
  '';

  # FIXME: make gdk_pixbuf dependency optional
  # Happens with 0.7.1 and 0.7.2
  # OSError: dlopen() failed to load a library: gdk_pixbuf-2.0 / gdk_pixbuf-2.0-0

  patches = [
    # This patch from PR substituted upstream
    (fetchpatch {
      url = "https://github.com/avnik/cairocffi/commit/2266882e263c5efc87350cf016d117b2ec6a1d59.patch";
      sha256 = "0gb570z3ivf1b0ixsk526n3h29m8c5rhjsiyam7rr3x80dp65cdl";
    })

    ./dlopen-paths.patch
    ./fix_test_scaled_font.patch
  ];

  postPatch = ''
    # Hardcode cairo library path
    substituteInPlace cairocffi/__init__.py --subst-var-by cairo ${cairo.out}
    substituteInPlace cairocffi/__init__.py --subst-var-by glib ${glib.out}
    substituteInPlace cairocffi/__init__.py --subst-var-by gdk_pixbuf ${gdk_pixbuf.out}
  '';

  meta = {
    homepage = https://github.com/SimonSapin/cairocffi;
    license = "bsd";
    description = "cffi-based cairo bindings for Python";
  };
}
