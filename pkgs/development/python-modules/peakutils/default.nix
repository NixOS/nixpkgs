{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pandas,
  pytestCheckHook,
  scipy,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "peakutils";
  version = "1.3.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-T/Ln8zMLkwJP6Noe4E4AOJ4mvLLveb0vnPhszUli4RQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pandas
    pytestCheckHook
  ];

  pythonImportsCheck = [ "peakutils" ];

  meta = {
    description = "Peak detection utilities for 1D data";
    homepage = "https://pypi.org/project/PeakUtils/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
