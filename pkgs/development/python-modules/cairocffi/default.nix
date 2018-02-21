# FIXME: make gdk_pixbuf dependency optional
{ buildPythonPackage
, fetchPypi
, lib
, substituteAll
, makeFontsConf
, freefont_ttf
, pytest
, glibcLocales
, cairo
, cffi
, withXcffib ? false, xcffib
, python
, glib
, gdk_pixbuf }:

buildPythonPackage rec {
  pname = "cairocffi";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i9m3p39g9wrkpjvpawch2qmnmm3cnim7niz3nmmbcp2hrkixwk5";
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

  patches = [
    # OSError: dlopen() failed to load a library: gdk_pixbuf-2.0 / gdk_pixbuf-2.0-0
    (substituteAll {
      src = ./dlopen-paths.patch;
      cairo = cairo.out;
      glib = glib.out;
      gdk_pixbuf = gdk_pixbuf.out;
    })
    ./fix_test_scaled_font.patch
  ];

  meta = with lib; {
    homepage = https://github.com/SimonSapin/cairocffi;
    license = licenses.bsd3;
    maintainers = with maintainers; [];
    description = "cffi-based cairo bindings for Python";
  };
}
