{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  opentelemetry-api,
  opentelemetry-test-utils,
  setuptools,
  wrapt,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation";
  version = "0.47b0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # to avoid breakage, every package in opentelemetry-python-contrib must inherit this version, src, and meta
  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "refs/tags/v${version}";
    hash = "sha256-XtJ4u891vI7wDtReoucm+qk3BkKJ+aZrYy7zfxmqfgk=";
  };

  sourceRoot = "${src.name}/opentelemetry-instrumentation";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    setuptools
    wrapt
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation" ];

  passthru.updateScript = opentelemetry-api.updateScript;

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/opentelemetry-instrumentation";
    description = "Instrumentation Tools & Auto Instrumentation for OpenTelemetry Python";
    changelog = "https://github.com/open-telemetry/opentelemetry-python-contrib/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = teams.deshaw.members ++ [ maintainers.natsukium ];
  };
}
