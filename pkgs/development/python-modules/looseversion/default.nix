{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "looseversion";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-695l8/a7lTGoEBbG/vPrlaYRga3Ee3+UnpwOpHkRZp4=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "looseversion" ];

  meta = with lib; {
    description = "Version numbering for anarchists and software realists";
    homepage = "https://github.com/effigies/looseversion";
    changelog = "https://github.com/effigies/looseversion/blob/${version}/CHANGES.md";
    license = licenses.psfl;
    maintainers = with maintainers; [ pelme ];
  };
}
