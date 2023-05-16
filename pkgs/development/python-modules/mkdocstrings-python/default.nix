{ lib
, buildPythonPackage
, fetchFromGitHub
, griffe
, mkdocs-material
, mkdocstrings
, pdm-backend
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mkdocstrings-python";
<<<<<<< HEAD
  version = "1.6.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "0.10.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "python";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-jppuuzROhVqNHm44gITpnC+xSN4s3ueY00N9v+IoJfE=";
=======
    rev = version;
    hash = "sha256-VGPlOHQNtXrfmcne93xDIxN20KDGlTQrjeAKhX/L6K0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    griffe
    mkdocstrings
  ];

  nativeCheckInputs = [
    mkdocs-material
    pytestCheckHook
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'license = "ISC"' 'license = {text = "ISC"}' \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "mkdocstrings_handlers"
  ];

  meta = with lib; {
    description = "Python handler for mkdocstrings";
    homepage = "https://github.com/mkdocstrings/python";
    changelog = "https://github.com/mkdocstrings/python/blob/${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
