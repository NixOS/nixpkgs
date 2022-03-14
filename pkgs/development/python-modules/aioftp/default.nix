{ lib
, async-timeout
, buildPythonPackage
, fetchPypi
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, siosocks
, trustme
}:

buildPythonPackage rec {
  pname = "aioftp";
  version = "0.20.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6p3n5tNNQrbwHqGRXYNL4+cf31Blx2e9elxX6/wxj/4=";
  };

  propagatedBuildInputs = [
    siosocks
  ];

  checkInputs = [
    async-timeout
    pytest-asyncio
    pytestCheckHook
    trustme
  ];

  pythonImportsCheck = [
    "aioftp"
  ];

  meta = with lib; {
    description = "Python FTP client/server for asyncio";
    homepage = "https://github.com/aio-libs/aioftp";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
