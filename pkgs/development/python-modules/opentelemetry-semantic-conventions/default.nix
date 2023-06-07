{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "opentelemetry-semantic-conventions";
  version = "1.18.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-82L/tDoWgu0r+Li3CS3hjVR99DQQmA5yt3y85+37imI=";
    sparseCheckout = [ "/${pname}" ];
  } + "/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.semconv" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-semantic-conventions";
    description = "OpenTelemetry Semantic Conventions";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
