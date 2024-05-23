{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  rply,
}:

buildPythonPackage rec {
  pname = "rnc2rng";
  version = "2.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3Z/7vWnQnLB+bnqM+A/ShwP9xtO5Am+HVrScvjMUZ2s=";
  };

  propagatedBuildInputs = [ rply ];

  checkPhase = "${python.interpreter} test.py";

  meta = with lib; {
    homepage = "https://github.com/djc/rnc2rng";
    description = "Compact to regular syntax conversion library for RELAX NG schemata";
    mainProgram = "rnc2rng";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
