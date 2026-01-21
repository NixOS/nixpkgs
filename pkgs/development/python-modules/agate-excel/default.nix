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
  version = "0.4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7tHcYjnw6Wcg2WLcG9+0SW4ZaHMyyCf9ix5YepF+ogI=";
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
