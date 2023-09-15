{ lib
, buildPythonPackage
, fetchFromGitHub
, dill
, pox
, ppft
, multiprocess
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pathos";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = pname;
    rev = "refs/tags/pathos-${version}";
    hash = "sha256-uQv1t3TRbvoQv86wNOdc5k0cgKt9kvnw5/DGbbbE46w=";
  };

  propagatedBuildInputs = [
    dill
    pox
    ppft
    multiprocess
  ];

  # Require network
  doCheck = false;

  pythonImportsCheck = [
    "pathos"
  ];

  meta = with lib; {
    description = "Parallel graph management and execution in heterogeneous computing";
    homepage = "https://pathos.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
