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
  version = "1.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5SWJnTxRm6mzP0RxrgA+jnV+Gp23WjqQA57wbT2V9Dk=";
  };

  propagatedBuildInputs = [
    urllib3
    python-dateutil
  ];

  checkInputs = [
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
