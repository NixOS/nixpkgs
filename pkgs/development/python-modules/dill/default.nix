{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "dill";
  version = "0.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6d6046f9f9195206063dd0415dff185ad593d6ee8b0e67f12597c0f4df4986f";
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