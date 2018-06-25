{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "dill";
  version = "0.2.8.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "53a6d7bf74f737a514cb89f72d0cb8b80dbd44a9cbbffaa14bffb57f4d7c3822";
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