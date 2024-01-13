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
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g/Eth99LlyiguP2hdWWFqw1lKxB7q1nGCE4bGtaSq0U=";
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
