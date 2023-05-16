{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pysigma
, pysigma-pipeline-sysmon
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysigma-backend-splunk";
<<<<<<< HEAD
  version = "1.0.3";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-splunk";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-ZDRHCzNLwBx8cugNVSkk7lZhE7MzariX0OS4pHv0f1s=";
=======
    hash = "sha256-SWD3Jw1wehWLvWkLA7rotweExYCrabq7men22D0zN5w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pysigma
  ];

  nativeCheckInputs = [
    pysigma-pipeline-sysmon
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sigma.backends.splunk"
  ];

  meta = with lib; {
    description = "Library to support Splunk for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-splunk";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
