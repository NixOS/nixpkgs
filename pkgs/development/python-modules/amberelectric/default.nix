{ lib
, buildPythonPackage
, fetchPypi
, pytest-mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, urllib3
}:

buildPythonPackage rec {
  pname = "amberelectric";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HujjqJ3nkPIj8P0qAiQnQzLhji5l8qOAO2Gh53OJ7UY=";
  };

  propagatedBuildInputs = [
    urllib3
    python-dateutil
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "amberelectric" ];

  meta = with lib; {
    description = "Python Amber Electric API interface";
    homepage = "https://github.com/madpilot/amberelectric.py";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
