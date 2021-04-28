{ lib
, buildPythonPackage
, fetchPypi
, python
, rply
}:

buildPythonPackage rec {
  pname = "rnc2rng";
  version = "2.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d354afcf0bf8e3b1e8f8d37d71a8fe5b1c0cf75cbd4b71364a9d90b5108a16e5";
  };

  propagatedBuildInputs = [ rply ];

  checkPhase = "${python.interpreter} test.py";

  meta = with lib; {
    homepage = "https://github.com/djc/rnc2rng";
    description = "Compact to regular syntax conversion library for RELAX NG schemata";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
