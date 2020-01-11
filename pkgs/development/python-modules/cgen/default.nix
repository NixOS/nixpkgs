{ lib
, buildPythonPackage
, fetchPypi
, pytools
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "cgen";
  version = "2019.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04gxzfjy2f9qsg3scg1sx4q4rhw5p036dyqngxyfsai0wvj5ya6m";
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
