{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,

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

  patches = [
    # Starting with Python 3.14, both `-X` and `--xxx` are surrounded
    # by ANSI color codes in the argparse help text.
    (fetchpatch {
      url = "https://github.com/nose-devs/nose2/commit/2043fdfa264dc04e379e11c227e63a5704cb0185.patch";
      hash = "sha256-OWzBInMI0ef9g0H3muka7J7FP01IZEFkuzJfaku78bI=";
    })
  ];

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
