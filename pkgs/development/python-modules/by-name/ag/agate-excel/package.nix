{
  lib,
  fetchPypi,
  buildPythonPackage,
  agate,
  openpyxl,
  xlrd,
  olefile,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "agate-excel";
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "Adds read support for excel files to agate";
    homepage = "https://github.com/wireservice/agate-excel";
    changelog = "https://github.com/wireservice/agate-excel/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
