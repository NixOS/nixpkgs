<<<<<<< HEAD
{ lib
, blessed
, buildPythonPackage
, fetchPypi
, mockito
, nvidia-ml-py
, psutil
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, setuptools-scm
=======
{ buildPythonPackage
, blessed
, fetchPypi
, lib
, mockito
, nvidia-ml-py
, psutil
, pytest-runner
, pythonRelaxDepsHook
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "gpustat";
<<<<<<< HEAD
  version = "1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yPwQVASqwRiE9w7S+gbP0hDTzTicyuSpvDhXnHJGDO4=";
  };

  pythonRelaxDeps = [
    "nvidia-ml-py"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
  ];
=======
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WB6P+FjDLJWjIruPA/HZ3D0Xe07LM93L7Sw3PGf04/E=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [ "nvidia-ml-py" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    blessed
    nvidia-ml-py
    psutil
  ];

  nativeCheckInputs = [
    mockito
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "gpustat"
  ];
=======
  pythonImportsCheck = [ "gpustat" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A simple command-line utility for querying and monitoring GPU status";
    homepage = "https://github.com/wookayin/gpustat";
<<<<<<< HEAD
    changelog = "https://github.com/wookayin/gpustat/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ billhuang ];
  };
}
