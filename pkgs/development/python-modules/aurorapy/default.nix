{ lib
, buildPythonPackage
, fetchFromGitLab
, future
, pyserial
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "aurorapy";
  version = "0.2.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "energievalsabbia";
    repo = pname;
    rev = version;
    hash = "sha256-rGwfGq3zdoG9NCGqVN29Q4bWApk5B6CRdsW9ctWgOec=";
  };

  propagatedBuildInputs = [
    future
    pyserial
  ];

  checkInputs = [
    pytestCheckHook
    six
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
