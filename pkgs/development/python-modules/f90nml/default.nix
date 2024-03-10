{ lib, buildPythonPackage, fetchFromGitHub, python, setuptools-scm }:

buildPythonPackage rec {
  pname = "f90nml";
  version = "1.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "marshallward";
    repo = pname;
    rev = "v" + version;
    hash = "sha256-nSpVBAS2VvXIQwYK/qVVzEc13bicAQ+ScXpO4Rn2O+8=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  pythonImportsCheck = [ "f90nml" ];

  meta = with lib; {
    description = "Python module for working with Fortran Namelists";
    homepage = "https://f90nml.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ loicreynier ];
  };
}
