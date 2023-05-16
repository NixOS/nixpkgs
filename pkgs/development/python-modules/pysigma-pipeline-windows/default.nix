{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pysigma
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysigma-pipeline-windows";
<<<<<<< HEAD
  version = "1.1.1";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-windows";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-279+nP5IeZiIjKNhJ2adbcJSDzcu7yqIB5JNFK5CPF0=";
=======
    hash = "sha256-jXUTGt/kbw6XfxA7A+t9km5GdltV1VRBTUf4lw1AwO4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pysigma
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sigma.pipelines.windows"
  ];

  meta = with lib; {
    description = "Library to support Windows service pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-windows";
    changelog = "https://github.com/SigmaHQ/pySigma-pipeline-windows/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
