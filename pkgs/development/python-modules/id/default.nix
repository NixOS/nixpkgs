{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pretend,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "id";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "di";
    repo = "id";
    tag = "v${version}";
    hash = "sha256-6Vkbs/i1roAtPGwLxdM+XKDrMTo0+NfVpAUpw6GPg9U=";
  };

  build-system = [ flit-core ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pretend
    pytestCheckHook
  ];

  pythonImportsCheck = [ "id" ];

  meta = with lib; {
    description = "Tool for generating OIDC identities";
    homepage = "https://github.com/di/id";
    changelog = "https://github.com/di/id/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
