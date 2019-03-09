# FIXME: make gdk_pixbuf dependency optional
{ stdenv
, buildPythonPackage
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
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01ac51ae12c4324ca5809ce270f9dd1b67f5166fe63bd3e497e9ea3ca91946ff";
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
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
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
