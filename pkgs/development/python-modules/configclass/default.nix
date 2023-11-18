{ lib
, fetchPypi
, buildPythonPackage
, mergedict
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "configclass";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aoDKBuDxJCeXbVwCXhse6FCbDDM30/Xa8p9qRvDkWBk=";
  };

  propagatedBuildInputs = [ mergedict ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "configclass" ];

  meta = with lib; {
    description = "A Python to class to hold configuration values";
    homepage = "https://github.com/schettino72/configclass/";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
