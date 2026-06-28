{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  networkx,
  numpy,
  scipy,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "geometric";
  version = "1.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "leeping";
    repo = "geomeTRIC";
    tag = version;
    hash = "sha256-LY5eNKocJL/Ty8tLup6q2o5RkGfIp6P6Hmju4wF3cDw=";
  };

  propagatedBuildInputs = [
    networkx
    numpy
    scipy
    six
  ];

  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Geometry optimization code for molecular structures";
    mainProgram = "geometric-optimize";
    homepage = "https://github.com/leeping/geomeTRIC";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.markuskowa ];
  };
}
