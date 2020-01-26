{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "dill";
  version = "0.3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42d8ef819367516592a825746a18073ced42ca169ab1f5f4044134703e7a049c";
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
    homepage = "https://github.com/uqfoundation/dill/";
    license = lib.licenses.bsd3;
  };
}
