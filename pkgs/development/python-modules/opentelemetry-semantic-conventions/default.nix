{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
}:

buildPythonPackage rec {
  pname = "opentelemetry-semantic-conventions";
  version = "1.17.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "v${version}";
    hash = "sha256-vYbkdDcmekT7hhFb/ivp5/0QakHd0DzMRLZEIjVgXkE=";
  };
  sourceRoot = "source/opentelemetry-semantic-conventions";

  nativeBuildInputs = [
    hatchling
  ];

  pythonImportsCheck = [ "opentelemetry.semconv" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
