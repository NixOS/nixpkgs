{
  lib,
  fetchPypi,
  buildPythonPackage,
  agate,
  openpyxl,
  xlrd,
  olefile,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "agate-excel";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KEJmGMkHRxEebVZumD2Djx4vrmQeppcNessOnUs4QJE=";
  };

  propagatedBuildInputs = [
    agate
    openpyxl
    xlrd
    olefile
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "agate" ];

  meta = {
    description = "Adds read support for excel files to agate";
    homepage = "https://github.com/wireservice/agate-excel";
    changelog = "https://github.com/wireservice/agate-excel/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
