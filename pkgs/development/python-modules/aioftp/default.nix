{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, pytest-asyncio
, pytest-cov
, trustme
, async-timeout
}:

buildPythonPackage rec {
  pname = "aioftp";
  version = "0.19.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1c2571764c48e6de1b02952022c3c3b3da1f10806cb342ec7b1fa9b109e9902";
  };

  checkInputs = [
    pytest
    pytest-asyncio
    pytest-cov
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
