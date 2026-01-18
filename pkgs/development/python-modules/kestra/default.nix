{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  amazon-ion,
  python-dateutil,
  pytestCheckHook,
  pytest-mock,
  requests-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "kestra";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kestra-io";
    repo = "libs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JpePlqwjIalbkVMIIqZ4z6YfkvjyuYUbhXcD2Z6hp/Y=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  build-system = [ setuptools ];

  dependencies = [
    requests
    amazon-ion
    python-dateutil
  ];

  pythonImportsCheck = [ "kestra" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
    pytest-mock
  ];

  meta = {
    description = "Infinitely scalable orchestration and scheduling platform, creating, running, scheduling, and monitoring millions of complex pipelines";
    homepage = "https://github.com/kestra-io/libs";
    changelog = "https://github.com/kestra-io/libs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ DataHearth ];
  };
})
