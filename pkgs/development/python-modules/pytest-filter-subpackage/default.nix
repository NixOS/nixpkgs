{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytest-cov
, pytest-doctestplus
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-filter-subpackage";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-H66jZxeAPlJFiNbBCdJtINOzRCLo1qloEnWJd9ygF4I=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    pytest-doctestplus
    pytest-cov
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # missing some files
  disabledTests = [ "with_rst" ];

  meta = with lib; {
    description = "Meta-package containing dependencies for testing";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
  };
}
