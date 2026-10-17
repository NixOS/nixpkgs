{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # optional-dependencies
  coverage,

  # tests
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "nose2";
  version = "0.16.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gdta0g4mRQGo7mTj4VejdmpedEFw5Uzuy05coJsIZVo=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    coverage_plugin = [ coverage ];
  };

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "nose2" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Test runner for Python";
    homepage = "https://github.com/nose-devs/nose2";
    changelog = "https://github.com/nose-devs/nose2/blob/${version}/docs/changelog.rst";
    license = lib.licenses.bsd0;
    maintainers = [ ];
    mainProgram = "nose2";
  };
}
