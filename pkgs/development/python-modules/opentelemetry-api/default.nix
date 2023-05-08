{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, deprecated
, importlib-metadata
, setuptools
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "opentelemetry-api";
  version = "1.17.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "v${version}";
    hash = "sha256-vYbkdDcmekT7hhFb/ivp5/0QakHd0DzMRLZEIjVgXkE=";
  };
  sourceRoot = "source/opentelemetry-api";

  nativeBuildInputs = [
    hatchling
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    deprecated
    importlib-metadata
    setuptools
  ];

  pythonRelaxDeps = [ "importlib-metadata" ];
  pythonImportsCheck = [ "opentelemetry" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
