{
  lib,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
  multiprocess,
  pox,
  ppft,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pathos";
  version = "0.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-b4HCiAvBGkFMxWh2PHC2kZ9G4PsQqVhKeIxLBKj09jU=";
  };

  propagatedBuildInputs = [
    dill
    pox
    ppft
    multiprocess
  ];

  # Require network
  doCheck = false;

  pythonImportsCheck = [ "pathos" ];

  meta = with lib; {
    description = "Parallel graph management and execution in heterogeneous computing";
    homepage = "https://pathos.readthedocs.io/";
    changelog = "https://github.com/uqfoundation/pathos/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
