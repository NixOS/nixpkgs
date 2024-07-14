{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytools,
  numpy,
  pytest,
}:

buildPythonPackage rec {
  pname = "cgen";
  version = "2020.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TsmdDIMtn5X15R3RimKa1Q3wtUZM5VfvQsbgzZR4v88=";
  };

  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [
    pytools
    numpy
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "C/C++ source generation from an AST";
    homepage = "https://github.com/inducer/cgen";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
