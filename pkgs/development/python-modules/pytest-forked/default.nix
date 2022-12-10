{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools-scm
, py
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-forked";
  version = "1.4.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-i2dYfI+Yy7rf3YBFOe1UVbbtA4AiA0hd0vU8FCLXRA4=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    py
  ];

  checkInputs = [ pytestCheckHook ];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Run tests in isolated forked subprocesses";
    homepage = "https://github.com/pytest-dev/pytest-forked";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
