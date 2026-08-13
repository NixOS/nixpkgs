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

buildPythonPackage (finalAttrs: {
  pname = "hist";
  version = "2.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-kusfoMo5utYZ9/cEs7qTxEs1U7BEX22ywXxnwBuctTQ=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    boost-histogram
    histoprint
    numpy
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mpl
  ];

  pythonImportsCheck = [ "hist" ];

  meta = {
    description = "Histogramming for analysis powered by boost-histogram";
    mainProgram = "";
    homepage = "https://hist.readthedocs.io/";
    changelog = "https://github.com/scikit-hep/hist/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
