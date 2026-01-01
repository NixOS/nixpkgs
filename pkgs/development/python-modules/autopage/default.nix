{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "autopage";
  version = "0.5.2";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gmmW10xaqfS2kWGVVHMSrGOEusOBC4UXBj8pMkgle3I=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "autopage" ];

<<<<<<< HEAD
  meta = {
    description = "Library to provide automatic paging for console output";
    homepage = "https://github.com/zaneb/autopage";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
=======
  meta = with lib; {
    description = "Library to provide automatic paging for console output";
    homepage = "https://github.com/zaneb/autopage";
    license = licenses.asl20;
    teams = [ teams.openstack ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
