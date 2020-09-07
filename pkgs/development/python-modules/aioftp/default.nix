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
  version = "0.17.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8433ff21317e71ef1f4d8cb8f7fe58365c04b5174142d9643e22343cfb35da1b";
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
