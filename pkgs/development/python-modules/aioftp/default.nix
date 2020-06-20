{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, pytest-asyncio
, pytestcov
, trustme
, async-timeout
}:

buildPythonPackage rec {
  pname = "aioftp";
  version = "0.16.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "94648d17dd3ca44614b59e8f795991b447258d82aa1b4cfecc0aceccf01b7495";
  };

  checkInputs = [
    pytest
    pytest-asyncio
    pytestcov
    trustme
    async-timeout
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Ftp client/server for asyncio";
    homepage = "https://github.com/aio-libs/aioftp";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
