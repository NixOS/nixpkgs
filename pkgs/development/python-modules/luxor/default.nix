{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest-aiohttp
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "luxor";
  version = "0.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "GIwVEOKZAudTu2M3OM4LFVR8e22q52m/AN0anskdmWQ=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "luxor"
  ];

  meta = with lib; {
    description = "Python module to control FX Luminaire controllers";
    homepage = "https://github.com/pbozeman/luxor";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
