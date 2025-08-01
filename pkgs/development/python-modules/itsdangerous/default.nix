{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  flit-core,
  freezegun,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "itsdangerous";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4AUMC32h7qU/+vFJwM+7XG4uK2nEvvIsgfputz5fYXM=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/pallets/itsdangerous/blob/${version}/CHANGES.rst";
    description = "Safely pass data to untrusted environments and back";
    homepage = "https://itsdangerous.palletsprojects.com";
    license = licenses.bsd3;
  };
}
