{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dbutils";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "DBUtils";
    hash = "sha256-reefvFeG10ltQThyL7yiQ0DPfHO11m3wUpb2Vv8Ia78=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dbutils" ];

  meta = {
    description = "Database connections for multi-threaded environments";
    homepage = "https://webwareforpython.github.io/DBUtils/";
    changelog = "https://webwareforpython.github.io/DBUtils/changelog.html";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
