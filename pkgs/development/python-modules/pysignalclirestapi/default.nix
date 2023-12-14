{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, requests
, future
}:

buildPythonPackage rec {
  pname = "pysignalclirestapi";
  version = "0.3.22";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "bbernhard";
    repo = "pysignalclirestapi";
    rev = version;
    hash = "sha256-m8Sihf5vTDntd5Tbaa5o55G/k/rqtmjWreoTab58CHU=";
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
