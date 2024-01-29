{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-sdk
, opentelemetry-test-utils
, setuptools
, wrapt
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation";
  version = "0.43b0";
  disabled = pythonOlder "3.7";

  # to avoid breakage, every package in opentelemetry-python-contrib must inherit this version, src, and meta
  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "refs/tags/v${version}";
    hash = "sha256-fUyA3cPXAxO506usEWxOUX9xiapc8Ocnbx73LP6ghRE=";
  };

  sourceRoot = "${src.name}/opentelemetry-instrumentation";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-sdk
    setuptools
    wrapt
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/opentelemetry-instrumentation";
    description = "Instrumentation Tools & Auto Instrumentation for OpenTelemetry Python";
    changelog = "https://github.com/open-telemetry/opentelemetry-python-contrib/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = teams.deshaw.members ++ [ maintainers.natsukium ];
  };
}
