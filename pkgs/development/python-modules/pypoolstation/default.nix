{
  lib,
  aiohttp,
  backoff,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  poetry-core,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pypoolstation";
<<<<<<< HEAD
  version = "0.5.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GIRx66esht82tKBJDhCDrwPkxsdBPi1w9tSQ7itF0qQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
=======
  version = "0.5.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hSlEChNjoDToA0tgWQiusBEpL08SMuOeHRr9W7Qgh/U=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    aiohttp
    backoff
    importlib-metadata
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pypoolstation" ];

<<<<<<< HEAD
  meta = {
    description = "Python library to interact the the Poolstation platform";
    homepage = "https://github.com/cibernox/PyPoolstation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python library to interact the the Poolstation platform";
    homepage = "https://github.com/cibernox/PyPoolstation";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
