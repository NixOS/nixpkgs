{
  lib,
  aiohttp,
  cryptography,
  buildPythonPackage,
  fetchPypi,
  pyjwt,
  pythonOlder,
  setuptools,
  requests,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "roadlib";
<<<<<<< HEAD
  version = "1.6.0";
=======
  version = "1.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-WKlbYTIw7A5d4UCxeFgtQ1/dTecqQVzSheImnrb2Hmw=";
=======
    hash = "sha256-xiWX16bnEhy7Ykn0nEXpXLJJ5rsZrr2rYmu6WE5XhaQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    pyjwt
    requests
    sqlalchemy
  ];

  optional-dependencies = {
    async = [ aiohttp ];
  };

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "roadtools.roadlib" ];

<<<<<<< HEAD
  meta = {
    description = "ROADtools common components library";
    homepage = "https://pypi.org/project/roadlib/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "ROADtools common components library";
    homepage = "https://pypi.org/project/roadlib/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
