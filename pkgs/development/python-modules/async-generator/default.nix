{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "async-generator";
  version = "1.10";
  pyproject = true;

  src = fetchPypi {
    pname = "async_generator";
    inherit (finalAttrs) version;
    hash = "sha256-brs9EGwSkgqq5CzLb3h+9e79zdFm6j1ij6hHar5xIUQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [ "test_aclose_on_unstarted_generator" ];

  pythonImportsCheck = [ "async_generator" ];

  meta = {
    description = "Async generators and context managers for Python 3.5+";
    homepage = "https://github.com/python-trio/async_generator";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
