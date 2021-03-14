{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, pysnmp
, asynctest, pytestcov, pytestrunner, pytest-asyncio, pytest-trio, pytest-tornasync }:

buildPythonPackage rec {
  pname = "brother";
  version = "0.2.1";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "sha256-yOloGkOVhXcTt0PAjf3yWUItN1okO94DndRFsImiuz4=";
  };

  # pytest-error-for-skips is not packaged
  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --error-for-skips" ""
    substituteInPlace setup.py \
      --replace "\"pytest-error-for-skips\"" ""
  '';

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
