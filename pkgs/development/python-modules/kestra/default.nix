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
buildPythonPackage rec {
  pname = "kestra";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kestra-io";
    repo = "libs";
    tag = "v${version}";
    hash = "sha256-cDJ5c4HgwmBnRtAFp8gxCqpo8AYJcuI2tthQOXaSOmU=";
  };

  sourceRoot = "${src.name}/python";

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    amazon-ion
    python-dateutil
  ];

  pythonImportsCheck = [
    "kestra"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
    pytest-mock
  ];

  meta = {
    description = "Infinitely scalable orchestration and scheduling platform, creating, running, scheduling, and monitoring millions of complex pipelines";
    homepage = "https://github.com/kestra-io/libs";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ DataHearth ];
  };
}
