{ buildPythonPackage
, lib
<<<<<<< HEAD
, fetchFromGitHub
, setuptools-scm
, pythonOlder
, importlib-metadata
, callPackage
=======
, fetchPypi
, setuptools-scm
, pythonOlder
, importlib-metadata
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pluggy";
<<<<<<< HEAD
  version = "1.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pluggy";
    rev = "refs/tags/${version}";
    hash = "sha256-SzJu7ITdmUgusn8sz6fRBpxTMQncWIViP5NCAj4q4GM=";
=======
  version = "1.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ setuptools-scm ];

<<<<<<< HEAD
  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # To prevent infinite recursion with pytest
  doCheck = false;
<<<<<<< HEAD
  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    changelog = "https://github.com/pytest-dev/pluggy/blob/${src.rev}/CHANGELOG.rst";
=======

  meta = {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://github.com/pytest-dev/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
