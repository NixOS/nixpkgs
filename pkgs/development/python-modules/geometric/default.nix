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
  version = "1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "leeping";
    repo = "geomeTRIC";
    tag = version;
    hash = "sha256-+eZWqBmX3c1/NqeEL62E09zPp6GeKxImD8E7uo6a85o=";
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
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.markuskowa ];
  };
}
