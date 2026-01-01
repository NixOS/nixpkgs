{
  lib,
  buildPythonPackage,
  coverage,
  fetchFromGitHub,
  pytest,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-testmon";
<<<<<<< HEAD
  version = "2.2.0";
  pyproject = true;
=======
  version = "2.1.4";
  format = "pyproject";

  disabled = pythonOlder "3.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tarpas";
    repo = "pytest-testmon";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-BVQ7rEusbW0G1C6cUeHH7fZWndSErcBQfGNdw0/4eTg=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ coverage ];
=======
    hash = "sha256-T/dvNUg1O6bIGgix8YS52zgt1wT8Fol6CscqcS8MjcA=";
  };

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ coverage ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # The project does not include tests since version 1.3.0
  doCheck = false;

  pythonImportsCheck = [ "testmon" ];

<<<<<<< HEAD
  meta = {
    description = "Pytest plug-in which automatically selects and re-executes only tests affected by recent changes";
    homepage = "https://github.com/tarpas/pytest-testmon/";
    changelog = "https://github.com/tarpas/pytest-testmon/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dmvianna ];
=======
  meta = with lib; {
    description = "Pytest plug-in which automatically selects and re-executes only tests affected by recent changes";
    homepage = "https://github.com/tarpas/pytest-testmon/";
    changelog = "https://github.com/tarpas/pytest-testmon/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dmvianna ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
