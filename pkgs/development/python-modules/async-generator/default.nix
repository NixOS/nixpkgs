{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "async-generator";
  version = "1.10";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "async_generator";
    inherit version;
    hash = "sha256-brs9EGwSkgqq5CzLb3h+9e79zdFm6j1ij6hHar5xIUQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [ "test_aclose_on_unstarted_generator" ];

  pythonImportsCheck = [ "async_generator" ];

  meta = with lib; {
    description = "Async generators and context managers for Python 3.5+";
    homepage = "https://github.com/python-trio/async_generator";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
