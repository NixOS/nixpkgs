{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, pysnmp
, asynctest, pytestcov, pytestrunner, pytest-asyncio, pytest-trio, pytest-tornasync }:

buildPythonPackage rec {
  pname = "brother";
  version = "0.1.17";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "03gjcpbq8rwnjzplgwhwr8wb7a1zh940dr6iwnq9srklqzzj691m";
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
