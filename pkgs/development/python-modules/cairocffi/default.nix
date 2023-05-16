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
<<<<<<< HEAD
, pytestCheckHook
, cairo
, cffi
, flit-core
, numpy
, withXcffib ? false
, xcffib
=======
, pytest
, glibcLocales
, cairo
, cffi
, numpy
, withXcffib ? false
, xcffib
, python
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, glib
, gdk-pixbuf
}:

buildPythonPackage rec {
  pname = "cairocffi";
<<<<<<< HEAD
  version = "1.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eOa75HNXZAxFPQvpKfpJzQXM4uEobz0qHKnL2n79uLc=";
=======
  version = "1.4.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UJM5syzNjXsAwiBMMnNs3njbU6MuahYtMSR40lYmzZo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  nativeBuildInputs = [
    flit-core
  ];
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [ cairo cffi ]
    ++ lib.optional withXcffib xcffib;

<<<<<<< HEAD
  nativeCheckInputs = [
    numpy
    pikepdf
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cairocffi"
  ];

  meta = with lib; {
    changelog = "https://github.com/Kozea/cairocffi/blob/v${version}/NEWS.rst";
    homepage = "https://github.com/SimonSapin/cairocffi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
=======
  # pytestCheckHook does not work
  nativeCheckInputs = [ numpy pikepdf pytest glibcLocales ];

  checkPhase = ''
    py.test $out/${python.sitePackages}
  '';

  meta = with lib; {
    homepage = "https://github.com/SimonSapin/cairocffi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "cffi-based cairo bindings for Python";
  };
}
