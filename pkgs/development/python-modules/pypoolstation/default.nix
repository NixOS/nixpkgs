{ lib
, aiohttp
, backoff
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, importlib-metadata
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pypoolstation";
<<<<<<< HEAD
  version = "0.5.3";
=======
  version = "0.4.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
<<<<<<< HEAD
    inherit pname version;
    hash = "sha256-hszGCA2DDGQSh37lxp8G0bqHliH/+i2so5imDyzyOJw=";
=======
    pname = "PyPoolstation";
    inherit version;
    hash = "sha256-2smgsR5f2fzmutr4EjhyrFWrO9odTba0ux+0B6k3+9Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
<<<<<<< HEAD
    importlib-metadata
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pypoolstation"
  ];

  meta = with lib; {
    description = "Python library to interact the the Poolstation platform";
    homepage = "https://github.com/cibernox/PyPoolstation";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
