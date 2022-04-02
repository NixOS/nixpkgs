{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Cerberus";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "pyeve";
    repo = "cerberus";
    rev = version;
    sha256 = "03kj15cf1pbd11mxsik96m5w1m6p0fbdc4ia5ihzmq8rz28razpq";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export TESTDIR=$(mktemp -d)
    cp -R ./cerberus/tests $TESTDIR
    pushd $TESTDIR
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [
    "cerberus"
  ];

  meta = with lib; {
    homepage = "http://python-cerberus.org/";
    description = "Lightweight, extensible schema and data validation tool for Python dictionaries";
    license = licenses.mit;
  };
}
