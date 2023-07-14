# FIXME: make gdk-pixbuf dependency optional
{ stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, lib
, substituteAll
, makeFontsConf
, freefont_ttf
, pikepdf
, pytestCheckHook
, cairo
, cffi
, numpy
, withXcffib ? false
, xcffib
, glib
, gdk-pixbuf
, setuptools
}:

buildPythonPackage rec {
  pname = "cairocffi";
  version = "1.5.1";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Bxq3ty41MzALC/1VpSBWtP/cHtbmVneeKs7Ztwm4opU=";
  };

  patches = [
    # OSError: dlopen() failed to load a library: gdk-pixbuf-2.0 / gdk-pixbuf-2.0-0
    (substituteAll {
      src = ./dlopen-paths.patch;
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
      cairo = cairo.out;
      glib = glib.out;
      gdk_pixbuf = gdk-pixbuf.out;
    })
    ./fix_test_scaled_font.patch
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cairo cffi ]
    ++ lib.optional withXcffib xcffib;

  nativeCheckInputs = [
    numpy
    pikepdf
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/Kozea/cairocffi/blob/v${version}/NEWS.rst";
    homepage = "https://github.com/SimonSapin/cairocffi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    description = "cffi-based cairo bindings for Python";
  };
}
