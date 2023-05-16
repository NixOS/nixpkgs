{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, poetry-core
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "cerberus";
  version = "1.3.5";
  format = "pyproject";

  disabled = pythonOlder "3.9";
=======
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Cerberus";
  version = "1.3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pyeve";
    repo = "cerberus";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-4sVNM4zHc9nsrntmJVdE9nm47CSF0UOJPPI9z3Z2YDc=";
  };

  propagatedBuildInputs = [
    poetry-core
=======
    rev = version;
    sha256 = "03kj15cf1pbd11mxsik96m5w1m6p0fbdc4ia5ihzmq8rz28razpq";
  };

  propagatedBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
=======
  preCheck = ''
    export TESTDIR=$(mktemp -d)
    cp -R ./cerberus/tests $TESTDIR
    pushd $TESTDIR
  '';

  postCheck = ''
    popd
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "cerberus"
  ];

<<<<<<< HEAD
  disabledTestPaths = [
    # We don't care about benchmarks
    "cerberus/benchmarks/"
  ];

  meta = with lib; {
    description = "Schema and data validation tool for Python dictionaries";
    homepage = "http://python-cerberus.org/";
    changelog = "https://github.com/pyeve/cerberus/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
=======
  meta = with lib; {
    homepage = "http://python-cerberus.org/";
    description = "Lightweight, extensible schema and data validation tool for Python dictionaries";
    license = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
