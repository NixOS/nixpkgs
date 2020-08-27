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
  version = "0.17.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "87869958fa98c4691acad0815840a94c1b50c6925d037d4dbb51331ddf4911f3";
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
