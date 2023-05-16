{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, git
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "pdm-pep517";
<<<<<<< HEAD
  version = "1.1.4";
=======
  version = "1.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-f0kSHnC0Lcopb6yWIhDdLaB6OVdfxWcxN61mFjOyzz8=";
=======
    hash = "sha256-1PpzWmRffpWmvrNKK19+jgDZPdBDnXPzHMguQLW4/c4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  preCheck = ''
    HOME=$TMPDIR

    git config --global user.name nobody
    git config --global user.email nobody@example.com
  '';

  nativeCheckInputs = [
    pytestCheckHook
    git
    setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/pdm-project/pdm-pep517";
    description = "Yet another PEP 517 backend.";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
