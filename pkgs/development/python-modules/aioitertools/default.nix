{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, pythonAtLeast
, pythonOlder

# native
, flit-core

# propagates
, typing-extensions

# tests
, python
}:

buildPythonPackage rec {
  pname = "aioitertools";
  version = "0.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fR0dSgPUYsWghAeH098JjxJYR+DTi4M7MPj4y8RaFCA=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  pythonImportsCheck = [
    "aioitertools"
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Implementation of itertools, builtins, and more for AsyncIO and mixed-type iterables";
    license = licenses.mit;
    homepage = "https://pypi.org/project/aioitertools/";
    maintainers = with maintainers; [ teh ];
  };
}
