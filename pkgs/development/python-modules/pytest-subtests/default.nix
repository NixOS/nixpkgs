{ lib, buildPythonPackage, isPy27, fetchPypi, setuptools_scm, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pytest-subtests";
  version = "0.3.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mxg91mrn8672f8hwg0f31xkyarnq7q0hr4fvb9hcb09jshq2wk7";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "pytest plugin for unittest subTest() support and subtests fixture";
    homepage = "https://github.com/pytest-dev/pytest-subtests";
    license = licenses.mit;
  };
}
