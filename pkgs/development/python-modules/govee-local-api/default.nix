{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "govee-local-api";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Galorhallen";
    repo = "govee-local-api";
    tag = "v${version}";
    hash = "sha256-kAzV9zchgxB2CmdWOa1vRuhRDSE0qTon9sVvmo9AeB0=";
  };

  postPatch = ''
    # dont depend on poetry at runtime
    # https://github.com/Galorhallen/govee-local-api/pull/75/files#r1943826599
    sed -i '/poetry = "^1.8.5"/d' pyproject.toml
  '';

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "govee_local_api" ];

  meta = {
    description = "Library to communicate with Govee local API";
    homepage = "https://github.com/Galorhallen/govee-local-api";
    changelog = "https://github.com/Galorhallen/govee-local-api/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
