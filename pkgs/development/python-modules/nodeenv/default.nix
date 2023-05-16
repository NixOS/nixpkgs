{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, python
, pythonOlder
, setuptools
, which
}:

buildPythonPackage rec {
  pname = "nodeenv";
<<<<<<< HEAD
  version = "1.8.0";
=======
  version = "1.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ekalinin";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-aW/aNZbFXfP4bF/Nlvv419IDfaJRA1pJYM7awj+6Hz0=";
=======
    rev = version;
    hash = "sha256-X30PUiOMT/vXqmdSJKHTNNA8aLWavCUaKa7LzqkdLrk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  preFixup = ''
    substituteInPlace $out/${python.sitePackages}/nodeenv.py \
      --replace '["which", candidate]' '["${lib.getBin which}/bin/which", candidate]'
  '';

  pythonImportsCheck = [
    "nodeenv"
  ];

  disabledTests = [
    # Test requires coverage
    "test_smoke"
  ];

  meta = with lib; {
    description = "Node.js virtual environment builder";
    homepage = "https://github.com/ekalinin/nodeenv";
<<<<<<< HEAD
    changelog = "https://github.com/ekalinin/nodeenv/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
