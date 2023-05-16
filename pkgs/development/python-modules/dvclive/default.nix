{ lib
, buildPythonPackage
, dvc
, dvc-studio-client
, fetchFromGitHub
, funcy
, pytestCheckHook
, pythonOlder
, ruamel-yaml
, scmrepo
, setuptools-scm
, tabulate
}:

buildPythonPackage rec {
  pname = "dvclive";
<<<<<<< HEAD
  version = "2.16.0";
=======
  version = "2.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-VxZXZhbKtym1ow/dU3G4yu4X1GwCsXzcau/YocertzY=";
=======
    hash = "sha256-Wb0347y+oDFOctKjJUYPtqIFdsRm2wt16ZlQWDgjr7g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dvc
    dvc-studio-client
    funcy
    ruamel-yaml
    scmrepo
  ];

  # Circular dependency with dvc
  doCheck = false;

  pythonImportsCheck = [
    "dvclive"
  ];

  meta = with lib; {
    description = "Library for logging machine learning metrics and other metadata in simple file formats";
    homepage = "https://github.com/iterative/dvclive";
    changelog = "https://github.com/iterative/dvclive/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
