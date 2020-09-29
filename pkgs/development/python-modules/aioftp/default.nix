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
  version = "0.18.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f9d5b5ac910987daca4f7ad4a017530751e2107d2471c9f92a3e09b507cb2dc";
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
