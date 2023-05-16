{ lib
, buildPythonPackage
, fetchPypi
, importlib-resources
, importlib-metadata
, iso3166
, pycountry
, pytestCheckHook
, pytest-cov
, pythonOlder
<<<<<<< HEAD
, setuptools
, setuptools-scm
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "schwifty";
<<<<<<< HEAD
  version = "2023.6.0";
=======
  version = "2023.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-hDNAoITt2Ak5aVWmMgqg2oA9rDFsiuum5JXc7v7sspU=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

=======
    hash = "sha256-Un9J1Yzt080vZ3rzoVURNpMcAObBS8Jsn5kEQKUVxf0=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    iso3166
    pycountry
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-resources
  ] ++ lib.optionals (pythonOlder "3.7") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "schwifty"
  ];

  meta = with lib; {
    description = "Validate/generate IBANs and BICs";
    homepage = "https://github.com/mdomke/schwifty";
    license = licenses.mit;
    maintainers = with maintainers; [ milibopp ];
  };
}
