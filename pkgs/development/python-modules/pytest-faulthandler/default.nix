{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, pytest-mock
, pythonOlder
, faulthandler
}:

buildPythonPackage rec {
  pname = "pytest-faulthandler";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bvfy6yyh2zlsrkpfmxy17149752m9y6ji9d34qp44bnci83dkjq";
  };

  nativeBuildInputs = [ setuptools_scm pytest ];
  checkInputs = [ pytest-mock ];
  propagatedBuildInputs = lib.optional (pythonOlder "3.0") faulthandler;

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Py.test plugin that activates the fault handler module for tests";
    homepage = https://github.com/pytest-dev/pytest-faulthandler;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
