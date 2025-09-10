{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
  requests-mock,
}:
buildPythonPackage rec {
  pname = "kestra";
  version = "0.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kestra-io";
    repo = "libs";
    tag = "v${version}";
    hash = "sha256-WtwvOSgAcN+ly0CnkL0Y7lrO4UhSSiXmoAyGXP/hFtE=";
  };

  sourceRoot = "${src.name}/python";

  build-system = [
    setuptools
  ];

  preBuild = ''
    # Required for building the library (https://github.com/kestra-io/libs/blob/v0.20.0/python/setup.py#L20)
    # The path resolve to CWD, so README.md isn't picked in the parent folder
    ln -s ../README.md README.md
  '';

  dependencies = [
    requests
  ];

  pythonImportsCheck = [
    "kestra"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  meta = {
    description = "Infinitely scalable orchestration and scheduling platform, creating, running, scheduling, and monitoring millions of complex pipelines";
    homepage = "https://github.com/kestra-io/libs";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ DataHearth ];
  };
}
