{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  future,
  pythonOlder,
  ratelim,
  requests,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "geocoder";
  version = "1.38.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yZJTdMlhV30K7kA7Ceb46hlx2RPwEfAMpwx2vq96d+c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    future
    ratelim
    requests
    six
  ];

  pythonImportsCheck = [ "geocoder" ];

<<<<<<< HEAD
  meta = {
    description = "Module for geocoding";
    homepage = "https://pypi.org/project/geocoder/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module for geocoding";
    homepage = "https://pypi.org/project/geocoder/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
