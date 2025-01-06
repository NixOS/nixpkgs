{
  buildPythonPackage,
  lib,
  fetchPypi,
  scipy,
}:

buildPythonPackage rec {
  pname = "rmsd";
  version = "1.6.2";
  format = "setuptools";

  propagatedBuildInputs = [ scipy ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E5QIJRqYivSeMxdSOGNt0sbJ6ExHcyLRZ91X6saduto=";
  };

  pythonImportsCheck = [ "rmsd" ];

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
