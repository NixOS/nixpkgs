{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  unittestCheckHook,
  pythonOlder,
  gcc,
}:

buildPythonPackage rec {
  pname = "pycparser";
  version = "2.22";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SRyL6cBA9TkPW/RKWwd1K9B/Vu35kjgbBccBQ57sEPY=";
  };

  postPatch = ''
    substituteInPlace tests/test_util.py examples/using_cpp_libc.py pycparser/__init__.py \
      --replace-fail "'cpp'" "'${lib.getBin gcc}/bin/cpp'"
    substituteInPlace tests/test_util.py examples/using_gcc_E_libc.py \
      --replace-warn "'gcc'" "'${lib.getBin gcc}/bin/gcc'"
  '';

  build-system = [ setuptools ];

  disabled = pythonOlder "3.8";

  nativeCheckInputs = [
    unittestCheckHook
    gcc
  ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  meta = with lib; {
    description = "C parser in Python";
    homepage = "https://github.com/eliben/pycparser";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
