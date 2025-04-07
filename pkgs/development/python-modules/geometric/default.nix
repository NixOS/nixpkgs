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
    hash = "sha256-hxNzyuupktUWDzZXXJNsVoC6m/kyE1fbfY5K6LiO+x0=";
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

  meta = with lib; {
    description = "Geometry optimization code for molecular structures";
    mainProgram = "geometric-optimize";
    homepage = "https://github.com/leeping/geomeTRIC";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.markuskowa ];
  };
}
