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
  version = "1.6.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dhLsFGts45PitSVZxXw5FND3EOeHHWYrH8PZJEYoq+M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "rmsd" ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "Calculate root-mean-square deviation (RMSD) between two sets of cartesian coordinates";
    mainProgram = "calculate_rmsd";
    homepage = "https://github.com/charnley/rmsd";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Calculate root-mean-square deviation (RMSD) between two sets of cartesian coordinates";
    mainProgram = "calculate_rmsd";
    homepage = "https://github.com/charnley/rmsd";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      sheepforce
      markuskowa
    ];
  };
}
