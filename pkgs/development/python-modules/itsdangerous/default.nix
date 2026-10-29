{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  freezegun,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "itsdangerous";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-4AUMC32h7qU/+vFJwM+7XG4uK2nEvvIsgfputz5fYXM=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/pallets/itsdangerous/blob/${finalAttrs.version}/CHANGES.rst";
    description = "Safely pass data to untrusted environments and back";
    homepage = "https://itsdangerous.palletsprojects.com";
    license = lib.licenses.bsd3;
  };
})
