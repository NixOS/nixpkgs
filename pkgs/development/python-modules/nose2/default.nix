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
  version = "0.15.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NncPUZ31vs08v+C+5Ku/v5ufa0604DNh0oK378/E8N8=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    coverage_plugin = [ coverage ];
  };

  pythonImportsCheck = [ "nose2" ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    unittestCheckHook
  ];

  meta = {
    changelog = "https://github.com/nose-devs/nose2/blob/${version}/docs/changelog.rst";
    description = "Test runner for Python";
    mainProgram = "nose2";
    homepage = "https://github.com/nose-devs/nose2";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
}
