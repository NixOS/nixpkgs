{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, asgiref
, opentelemetry-api
, opentelemetry-sdk
}:

buildPythonPackage rec {
  pname = "tests/opentelemetry-test-utils";
  version = "1.17.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "v${version}";
    hash = "sha256-vYbkdDcmekT7hhFb/ivp5/0QakHd0DzMRLZEIjVgXkE=";
  };
  sourceRoot = "source/tests/opentelemetry-test-utils";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    asgiref
    opentelemetry-api
    opentelemetry-sdk
  ];

  pythonImportsCheck = [ "opentelemetry-test-utils" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
