{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  click,
  numpy,
  uhi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "histoprint";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "histoprint";
    tag = "v${version}";
    hash = "sha256-qMg0Ct39BjdcyWB3KxG74rVqVW4I0DGZ5GS7D3uYq3w=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    click
    numpy
    uhi
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pretty print histograms to the console";
    mainProgram = "histoprint";
    homepage = "https://github.com/scikit-hep/histoprint";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
