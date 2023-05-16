{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, numpy
, pandas
, scipy
}:

buildPythonPackage rec {
  pname = "formulae";
<<<<<<< HEAD
  version = "0.5.0";
  format = "pyproject";

=======
  version = "0.3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-WDWpyrHXGBfheE0m5I9K+Dk1urXRMY6yoenN3OaZogM=";
  };

  nativeBuildInputs = [ setuptools ];

=======
    rev = "refs/tags/v${version}";
    hash = "sha256-6IGTn3griooslN6+qRYLJiWaJhvsxa1xj1+1kQ57yN0=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    numpy
    pandas
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  # use assertions of form `assert pytest.approx(...)`, which is now disallowed:
  disabledTests = [ "test_basic" "test_degree" ];
  pythonImportsCheck = [
    "formulae"
    "formulae.matrices"
  ];

  meta = with lib; {
    homepage = "https://bambinos.github.io/formulae";
    description = "Formulas for mixed-effects models in Python";
<<<<<<< HEAD
    changelog = "https://github.com/bambinos/formulae/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
