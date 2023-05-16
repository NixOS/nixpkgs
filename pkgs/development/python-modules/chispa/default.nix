{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "chispa";
<<<<<<< HEAD
  version = "0.9.3";
=======
  version = "0.8.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MrPowers";
    repo = "chispa";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-C+fodrQ7PztGzFHAi9SF+rkwtf4bdjDE2u0uORDXBbE=";
=======
    rev = "v${version}";
    hash = "sha256-1ePx8VbU8pMd5EsZhFp6qyMptlUxpoCvJfuDm9xXOdc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    setuptools
  ];

  # Tests require a spark installation
  doCheck = false;

  # pythonImportsCheck needs spark installation

  meta = with lib; {
    description = "PySpark test helper methods with beautiful error messages";
    homepage = "https://github.com/MrPowers/chispa";
    license = licenses.mit;
    maintainers = with maintainers; [ ratsclub ];
  };
}
