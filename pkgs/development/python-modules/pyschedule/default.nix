{
  lib,
  buildPythonPackage,
  fetchPypi,
  pulp,
}:

buildPythonPackage rec {
  pname = "pyschedule";
  version = "0.2.34";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a7qenqB5Bs4t/jzYR8GCKxN/axPp+XXFCzRzEv2Y4RA=";
  };

  propagatedBuildInputs = [ pulp ];

  # tests not included with pypi release (in examples)
  doCheck = false;

  meta = with lib; {
    description = "Formulate and solve resource-constrained scheduling problems";
    homepage = "https://github.com/timnon/pyschedule";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
