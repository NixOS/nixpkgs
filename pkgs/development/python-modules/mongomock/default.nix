{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  packaging,
  pytestCheckHook,
  pytz,
  sentinels,
}:

buildPythonPackage (finalAttrs: {
  pname = "mongomock";
  version = "4.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
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

  meta = {
    description = "Fake pymongo stub for testing simple MongoDB-dependent code";
    homepage = "https://github.com/mongomock/mongomock";
    changelog = "https://github.com/mongomock/mongomock/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ gador ];
  };
})
