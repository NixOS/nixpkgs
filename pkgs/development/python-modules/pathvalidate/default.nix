{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pathvalidate";
<<<<<<< HEAD
  version = "3.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QmlwIm4kGZ/ZDZOZXSI8Hii9qWfN9DcHVaFM33KiqO4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

=======
  version = "2.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X/V9D6vl7Lek8eSVe/61rYq1q0wPpx95xrvCS9m30U0=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Requires `pytest-md-report`, causing infinite recursion.
  doCheck = false;

  pythonImportsCheck = [
    "pathvalidate"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Library to sanitize/validate a string such as filenames/file-paths/etc";
    homepage = "https://github.com/thombashi/pathvalidate";
    changelog = "https://github.com/thombashi/pathvalidate/releases/tag/v${version}";
=======
    description = "A Python library to sanitize/validate a string such as filenames/file-paths/etc";
    homepage = "https://github.com/thombashi/pathvalidate";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ oxalica ];
  };
}
