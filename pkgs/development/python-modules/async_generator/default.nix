{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "async-generator";
  version = "1.10";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "async_generator";
    inherit version;
    sha256 = "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "async_generator" ];

  meta = with lib; {
    description = "Async generators and context managers for Python 3.5+";
    homepage = "https://github.com/python-trio/async_generator";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
