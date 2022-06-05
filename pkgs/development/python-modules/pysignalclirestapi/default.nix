{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, future
}:

buildPythonPackage rec {
  pname = "pysignalclirestapi";
  version = "0.3.18";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bbernhard";
    repo = "pysignalclirestapi";
    rev = version;
    hash = "sha256-BF4BmnQVfrj7f0N+TN/d7GNuDTbDQfwsCkUn2pVmMWo=";
  };

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
