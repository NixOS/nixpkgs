{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-semantic-conventions
, setuptools
, typing-extensions
}:

buildPythonPackage rec {
  pname = "opentelemetry-sdk";
  version = "1.17.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "v${version}";
    hash = "sha256-vYbkdDcmekT7hhFb/ivp5/0QakHd0DzMRLZEIjVgXkE=";
  };
  sourceRoot = "source/opentelemetry-sdk";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-semantic-conventions
    setuptools
    typing-extensions
  ];

  pythonImportsCheck = [ "opentelemetry.sdk" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
