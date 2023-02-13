{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
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

  patches = [
    # pytest 7.2.0 compat, remove after 1.4.0
    (fetchpatch {
      url = "https://github.com/pytest-dev/pytest-forked/commit/c3c753e96916a4bc5a8a37699e75c6cbbd653fa2.patch";
      hash = "sha256-QPgxBeMQ0eKJyHXYZyBicVbE+JyKPV/Kbjsb8gNJBGA=";
    })
    (fetchpatch {
      url = "https://github.com/pytest-dev/pytest-forked/commit/de584eda15df6db7912ab6197cfb9ff23024ef23.patch";
      hash = "sha256-VLE32xZRwFK0nEgCWuSoMW/yyFHEURtNFU9Aa9haLhk=";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    py
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
  ];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Run tests in isolated forked subprocesses";
    homepage = "https://github.com/pytest-dev/pytest-forked";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
