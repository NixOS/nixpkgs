{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "govee-local-api";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Galorhallen";
    repo = "govee-local-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-L9c/58B50E5Kk44j9tvtDZ0+ncJZ4KubTz/U9FI71+E=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "govee_local_api" ];

  meta = with lib; {
    description = "Library to communicate with Govee local API";
    homepage = "https://github.com/Galorhallen/govee-local-api";
    changelog = "https://github.com/Galorhallen/govee-local-api/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
