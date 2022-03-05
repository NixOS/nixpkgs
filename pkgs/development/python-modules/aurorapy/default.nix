{ lib
, buildPythonPackage
, fetchFromGitLab
, future
, pyserial
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aurorapy";
  version = "0.2.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "energievalsabbia";
    repo = pname;
    rev = version;
    hash = "sha256-DMlzzLe94dbeHjESmLc045v7vQ//IEsngAv7TeVznHE=";
  };

  propagatedBuildInputs = [
    future
    pyserial
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aurorapy"
  ];

  meta = with lib; {
    description = "Implementation of the communication protocol for Power-One Aurora inverters";
    homepage = "https://gitlab.com/energievalsabbia/aurorapy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
