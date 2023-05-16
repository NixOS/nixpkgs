{ lib
, buildPythonPackage
, coverage
, fetchFromGitHub
, poetry-core
, pytest
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pytest-testmon";
<<<<<<< HEAD
  version = "2.0.12";
=======
  version = "2.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tarpas";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-hv5sgWSbMk13h+nFTcy4aEMJvTyaLbXFhg6ZOKYEvVQ=";
=======
    hash = "sha256-hQJ52CuCBgxGcbbkbqsshh+lcevrgD8Xjde2ErghRKk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    coverage
  ];

  # The project does not include tests since version 1.3.0
  doCheck = false;

  pythonImportsCheck = [
    "testmon"
  ];

  meta = with lib; {
    description = "Pytest plug-in which automatically selects and re-executes only tests affected by recent changes";
    homepage = "https://github.com/tarpas/pytest-testmon/";
    changelog = "https://github.com/tarpas/pytest-testmon/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ dmvianna ];
  };
}
