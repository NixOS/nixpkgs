{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, pysnmp
, asynctest, pytestcov, pytestrunner, pytest-asyncio, pytest-trio, pytest-tornasync }:

buildPythonPackage rec {
  pname = "brother";
  version = "0.2.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "0d984apw73kzd6bid65bqhp26gvvgqjni56nqr0gnb2sv7mknnm8";
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
