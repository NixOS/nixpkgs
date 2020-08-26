{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, pysnmp
, asynctest, pytestcov, pytestrunner, pytest-asyncio, pytest-trio, pytest-tornasync }:

buildPythonPackage rec {
  pname = "brother";
  version = "0.1.14";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "11pkr30bxrzgbz6bi42dyhav6qhr7rz9fb6a13297g7wa77jn4r4";
  };

  propagatedBuildInputs = [
    pysnmp
  ];

  checkInputs = [
    asynctest
    pytestcov
    pytestrunner
    pytest-asyncio
    pytest-trio
    pytest-tornasync
  ];

  meta = with lib; {
    description = "Python wrapper for getting data from Brother laser and inkjet printers via SNMP.";
    homepage = "https://github.com/bieniu/brother";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
