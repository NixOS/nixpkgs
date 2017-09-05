{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "dill";
  version = "0.2.7.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97fd758f5fe742d42b11ec8318ecfcff8776bccacbfcec05dfd6276f5d450f73";
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