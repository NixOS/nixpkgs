{
  lib,
  fetchPypi,
  buildPythonPackage,
  boost-histogram,
  histoprint,
  hatchling,
  hatch-vcs,
  numpy,
  pytestCheckHook,
  pytest-mpl,
}:

buildPythonPackage rec {
  pname = "hist";
  version = "2.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kjxztsTVEicXXMgnk3vKl5Fgv+gxygmZJmUPcPabW2s=";
  };

  buildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    boost-histogram
    histoprint
    numpy
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mpl
  ];

  meta = {
    description = "Histogramming for analysis powered by boost-histogram";
    mainProgram = "hist";
    homepage = "https://hist.readthedocs.io/";
    changelog = "https://github.com/scikit-hep/hist/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
