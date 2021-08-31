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
  version = "0.18.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5a412c748722dd679c4c2e30dd40d70a7c8879636f6eb4489fdbca72965b125";
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
