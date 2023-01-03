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
  version = "1.4.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UJM5syzNjXsAwiBMMnNs3njbU6MuahYtMSR40lYmzZo=";
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

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" "" \
      --replace "pytest-cov" "" \
      --replace "pytest-flake8" "" \
      --replace "pytest-isort" "" \
      --replace "--flake8 --isort" ""
  '';

  LC_ALL = "en_US.UTF-8";

  # checkPhase require at least one 'normal' font and one 'monospace',
  # otherwise glyph tests fails
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cairo cffi ]
    ++ lib.optional withXcffib xcffib;

  # pytestCheckHook does not work
  checkInputs = [ numpy pikepdf pytest glibcLocales ];

  checkPhase = ''
    py.test $out/${python.sitePackages}
  '';

  meta = with lib; {
    homepage = "https://github.com/SimonSapin/cairocffi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
    description = "cffi-based cairo bindings for Python";
  };
}
