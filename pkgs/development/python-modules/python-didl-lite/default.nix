{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, defusedxml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-didl-lite";
  version = "1.3.1";
  disabled = pythonOlder "3.5.3";

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = pname;
    rev = version;
    sha256 = "sha256-qOhpS53isHP0IuM0E0oh2pm2naQjVU6MPHVUcI3vKo8=";
  };

  propagatedBuildInputs = [
    defusedxml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "didl_lite" ];

  meta = with lib; {
    description = "DIDL-Lite (Digital Item Declaration Language) tools for Python";
    homepage = "https://github.com/StevenLooman/python-didl-lite";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
