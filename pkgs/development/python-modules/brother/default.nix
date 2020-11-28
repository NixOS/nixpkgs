{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, pysnmp
, asynctest, pytestcov, pytestrunner, pytest-asyncio, pytest-trio, pytest-tornasync }:

buildPythonPackage rec {
  pname = "brother";
  version = "0.1.18";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "14fiwhgcgymgqsl9kcfb0597rcjxvdknhwbakpdf0xp2ph6cj266";
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
