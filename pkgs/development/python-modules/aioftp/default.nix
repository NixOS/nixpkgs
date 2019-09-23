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
  version = "0.13.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5711c03433b510c101e9337069033133cca19b508b5162b414bed24320de6c18";
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
    homepage = https://github.com/aio-libs/aioftp;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
