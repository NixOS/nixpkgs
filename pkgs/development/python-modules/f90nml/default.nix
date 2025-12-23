{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "f90nml";
  version = "1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marshallward";
    repo = "f90nml";
    rev = "v" + version;
    hash = "sha256-AtFyHCbt74246uFBhDjw144CfxVq8r7fsgDC36plz+I=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "f90nml" ];

  meta = {
    description = "Python module for working with Fortran Namelists";
    mainProgram = "f90nml";
    homepage = "https://f90nml.readthedocs.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ loicreynier ];
  };
}
