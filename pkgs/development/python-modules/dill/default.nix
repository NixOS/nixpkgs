{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "dill";
  version = "0.2.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "624dc244b94371bb2d6e7f40084228a2edfff02373fe20e018bef1ee92fdd5b3";
  };

  # Messy test suite. Even when running the tests like tox does, it fails
  doCheck = false;
  checkPhase = ''
    for test in tests/*.py; do
      ${python.interpreter} $test
    done
  '';
  # Following error without setting checkPhase
  # TypeError: don't know how to make test from: {'byref': False, 'recurse': False, 'protocol': 3, 'fmode': 0}

  meta = {
    description = "Serialize all of python (almost)";
    homepage = http://www.cacr.caltech.edu/~mmckerns/dill.htm;
    license = lib.licenses.bsd3;
  };
}