{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage rec {
  pname = "govee-local-api";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Galorhallen";
    repo = "govee-local-api";
    tag = "v${version}";
    hash = "sha256-JjrO9lOIrkp595+O6usa8wVrKmWyoywHEeIOP5HxL0Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.30,<0.12" "uv_build"
  '';

  build-system = [ uv-build ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "govee_local_api" ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "test_reuseaddr_and_broadcast_are_set"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Library to communicate with Govee local API";
    homepage = "https://github.com/Galorhallen/govee-local-api";
    changelog = "https://github.com/Galorhallen/govee-local-api/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
