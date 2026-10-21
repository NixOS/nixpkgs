{
  buildPythonPackage,
  lib,
  fetchPypi,
  numpy,
  scipy,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rmsd";
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VQz+mnootttCRJEcMA8Yx7VzmWCcdgHHSVkJ3JZXIX0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "rmsd" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Calculate root-mean-square deviation (RMSD) between two sets of cartesian coordinates";
    mainProgram = "calculate_rmsd";
    homepage = "https://github.com/charnley/rmsd";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      sheepforce
      markuskowa
    ];
  };
}
