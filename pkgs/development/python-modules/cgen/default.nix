{ lib
, buildPythonPackage
, fetchPypi
, pytools
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "cgen";
  version = "2017.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a04525d51ee975d37d590d6d82bf80a46e77f75187cccfd2248a89616a778795";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [
    pytools
    numpy
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "C/C++ source generation from an AST";
    homepage = https://github.com/inducer/cgen;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
