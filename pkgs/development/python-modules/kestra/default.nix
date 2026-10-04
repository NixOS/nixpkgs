{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  amazon-ion,
  python-dateutil,
  requests,

  # tests
  pytest-mock,
  pytestCheckHook,
  requests-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "kestra";
  version = "2.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kestra-io";
    repo = "libs";
    # No tags for 2.0.0. This is the commit corresponding to 2.0.0 on PyPI
    rev = "b21cb7bde0ab77755d617cccc46dab4db631fdcf";
    hash = "sha256-TdlztAih/SZdl3UWa/+SLwFGJ9lbQYcHC7moiUIcaOU=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  # setup.py reads the version from the environment (defaults to 0.0.0)
  env.VERSION = finalAttrs.version;

  build-system = [ setuptools ];

  dependencies = [
    amazon-ion
    python-dateutil
    requests
  ];

  pythonImportsCheck = [ "kestra" ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

  meta = {
    description = "Infinitely scalable orchestration and scheduling platform, creating, running, scheduling, and monitoring millions of complex pipelines";
    homepage = "https://github.com/kestra-io/libs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ DataHearth ];
  };
})
