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
  version = "0.16.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rqzg4w86zch0cjslkndv02gmpi0r27lsy1qi1irpa8hqfhh23ja";
  };

  checkInputs = [
    pytest
    pytest-asyncio
    pytestcov
    trustme
    async-timeout
  ];

  doCheck = false; # requires siosocks, not packaged yet
  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [ "aioftp" ];

  meta = with lib; {
    description = "Ftp client/server for asyncio";
    homepage = "https://github.com/aio-libs/aioftp";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
