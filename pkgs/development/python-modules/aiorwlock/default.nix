{
  buildPythonPackage,
  fetchPypi,
  lib,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiorwlock";
  version = "1.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TOpb7E6dA1M6JpGSmTlIIqFCKqUZvKndCReOxJD40cw=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "aiorwlock" ];

  meta = with lib; {
    description = "Read write lock for asyncio";
    homepage = "https://github.com/aio-libs/aiorwlock";
    license = licenses.asl20;
    maintainers = with maintainers; [ billhuang ];
  };
}
