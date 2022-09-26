{ buildPythonPackage
, fetchPypi
, lib
, pytest-asyncio
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiorwlock";
  version = "1.3.0";

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "83f12d87df4b9728a0b8fda1756585ab0d652b107bab59c6084e1b1ad692ab45";
  };

  meta = with lib; {
    description = "Read write lock for asyncio";
    homepage = "https://github.com/aio-libs/aiorwlock";
    license = licenses.asl20;
    maintainers = with maintainers; [ billhuang ];
  };
}
