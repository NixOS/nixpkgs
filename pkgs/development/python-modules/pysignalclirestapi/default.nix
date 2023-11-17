{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, requests
, future
}:

buildPythonPackage rec {
  pname = "pysignalclirestapi";
  version = "0.3.21";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "bbernhard";
    repo = "pysignalclirestapi";
    rev = version;
    hash = "sha256-CAZ6UgGz7ZDXlQlngi+hEhczOphvAT/Yl9vLqnrS1Qc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    requests
    future
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysignalclirestapi" ];

  meta = with lib; {
    description = "Small python library for the Signal Cli REST API";
    homepage = "https://github.com/bbernhard/pysignalclirestapi";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
