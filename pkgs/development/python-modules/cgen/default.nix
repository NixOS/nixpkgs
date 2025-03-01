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
    sha256 = "4ec99d0c832d9f95f5e51dd18a629ad50df0b5464ce557ef42c6e0cd9478bfcf";
  };

  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [
    pytools
    numpy
  ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description = "C/C++ source generation from an AST";
    homepage = "https://github.com/inducer/cgen";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
