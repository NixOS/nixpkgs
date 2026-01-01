{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "SciencePlots";
  version = "2.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2NGX40EPh+va0LnCZeqrWWCU+wgtlxI+g19rwygAq1Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ matplotlib ];

  pythonImportsCheck = [ "scienceplots" ];

  doCheck = false; # no tests

<<<<<<< HEAD
  meta = {
    description = "Matplotlib styles for scientific plotting";
    homepage = "https://github.com/garrettj403/SciencePlots";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kilimnik ];
=======
  meta = with lib; {
    description = "Matplotlib styles for scientific plotting";
    homepage = "https://github.com/garrettj403/SciencePlots";
    license = licenses.mit;
    maintainers = with maintainers; [ kilimnik ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
