{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, setuptools-scm
, typing-extensions
, toml
, zipp
}:

buildPythonPackage rec {
  pname = "importlib-metadata";
<<<<<<< HEAD
  version = "6.8.0";
=======
  version = "6.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-26zniS2MDErBrQlmYiMvgx1OZPTEVFvVMBaj6dRlR0M=";
=======
    hash = "sha256-41S+3rYO+mr/3MiuEhtzVEp6p0FW0EcxGUj21xHNN40=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools # otherwise cross build fails
    setuptools-scm
  ];

  propagatedBuildInputs = [
    toml
    zipp
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  # Cyclic dependencies due to pyflakefs
  doCheck = false;

  pythonImportsCheck = [
    "importlib_metadata"
  ];

  meta = with lib; {
    description = "Read metadata from Python packages";
    homepage = "https://importlib-metadata.readthedocs.io/";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ fab AndersonTorres ];
=======
    maintainers = with maintainers; [ fab ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
