# FIXME: make gdk-pixbuf dependency optional
{ stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, lib
, substituteAll
, makeFontsConf
, freefont_ttf
, pytest
, glibcLocales
, cairo
, cffi
, numpy
, withXcffib ? false
, xcffib
, python
, glib
, gdk-pixbuf
}:

buildPythonPackage rec {
  pname = "cairocffi";
  version = "1.3.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EIo6fLCeIDvdhQHZuq2R14bSBFYb1x6TZOizSJfEe5E=";
  };

  LC_ALL = "en_US.UTF-8";

  # checkPhase require at least one 'normal' font and one 'monospace',
  # otherwise glyph tests fails
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  propagatedBuildInputs = [ cairo cffi ] ++ lib.optional withXcffib xcffib;
  propagatedNativeBuildInputs = [ cffi ];

  # pytestCheckHook does not work
  checkInputs = [ numpy pytest glibcLocales ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" "" \
      --replace "pytest-cov" "" \
      --replace "pytest-flake8" "" \
      --replace "pytest-isort" "" \
      --replace "--flake8 --isort" ""
  '';

  checkPhase = ''
    py.test $out/${python.sitePackages}
  '';

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

  meta = with lib; {
    homepage = "https://github.com/SimonSapin/cairocffi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
    description = "cffi-based cairo bindings for Python";
  };
}
