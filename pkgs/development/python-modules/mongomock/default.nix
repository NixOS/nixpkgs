{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  packaging,
  pytestCheckHook,
  pythonOlder,
  pytz,
  sentinels,
}:

buildPythonPackage rec {
  pname = "mongomock";
  version = "4.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MmZ7eQZvq8EtTxfxao/XNhtfRDUgizujLCJuUiEqjDA=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    packaging
    pytz
    sentinels
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mongomock" ];

  meta = with lib; {
    description = "Fake pymongo stub for testing simple MongoDB-dependent code";
    homepage = "https://github.com/mongomock/mongomock";
    changelog = "https://github.com/mongomock/mongomock/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gador ];
  };
}
