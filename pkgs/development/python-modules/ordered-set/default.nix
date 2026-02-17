{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ordered-set";
  version = "4.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aUqORMh2V8WSku3nKJHrkdNBMfZTFGOqswCRkcdzZKg=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ordered_set" ];

  meta = {
    description = "MutableSet that remembers its order, so that every entry has an index";
    homepage = "https://github.com/rspeer/ordered-set";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MostAwesomeDude ];
  };
}
