{
  lib,
  fetchPypi,
  buildPythonPackage,
  mergedict,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "configclass";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aoDKBuDxJCeXbVwCXhse6FCbDDM30/Xa8p9qRvDkWBk=";
  };

  propagatedBuildInputs = [ mergedict ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "configclass" ];

  meta = {
    description = "Python to class to hold configuration values";
    homepage = "https://github.com/schettino72/configclass/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
}
