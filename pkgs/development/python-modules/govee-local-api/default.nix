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
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Galorhallen";
    repo = "govee-local-api";
    tag = "v${version}";
    hash = "sha256-DjerH/51ta0Q3by47+Xo0Fp3nk4igum00mSZeoswYxM=";
  };

  postPatch = ''
    # dont depend on poetry at runtime
    # https://github.com/Galorhallen/govee-local-api/pull/75/files#r1943826599
    sed -i '/poetry = "^1.8.5"/d' pyproject.toml
  '';

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "govee_local_api" ];

  meta = with lib; {
    description = "Library to communicate with Govee local API";
    homepage = "https://github.com/Galorhallen/govee-local-api";
    changelog = "https://github.com/Galorhallen/govee-local-api/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
