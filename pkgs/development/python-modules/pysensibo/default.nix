{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysensibo";
  version = "1.0.35";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E3XUQ7Ltu9zhjWVvl1LN+UUz8B2dAjLa0CZI9ca35nc=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "pysensibo"
  ];

  meta = with lib; {
    description = "Module for interacting with Sensibo";
    homepage = "https://github.com/andrey-git/pysensibo";
    changelog = "https://github.com/andrey-git/pysensibo/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
