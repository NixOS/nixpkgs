{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  openssl,
  perl,
  pkg-config,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "cloudcheck";
  version = "11.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blacklanternsecurity";
    repo = "cloudcheck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rOMr7J6XZGjWq11Mlr3gkE7IpBlBeQ30gJ5uGXfbxTI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-OmWW3+nCx8a0X25kKQ97+MJlCb7mOh9WN4zI+3oOTd4=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    perl
    pkg-config
  ];

  env.SWAGGER_UI_DOWNLOAD_URL =
    let
      swaggerUi = fetchurl {
        url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.17.14.zip";
        hash = "sha256-SBJE0IEgl7Efuu73n3HZQrFxYX+cn5UU5jrL4T5xzNw=";
      };
    in
    "file://${swaggerUi}";

  buildInputs = [ openssl ];

  nativeCheckInputs = [
    pydantic
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "cloudcheck" ];

  disabledTestPaths = [
    # Test requires network access
    "cloudcheck_update/test_cloudcheck_update.py"
  ];

  disabledTests = [
    # Tests require network access
    "test_lookup_google_dns"
    "test_lookup_amazon_domain"
    "test_lookup_endpoint"
    "test_lookup_with_ssl_verification_disabled"
  ];

  preCheck = ''
    rm -rf cloudcheck
  '';

  meta = {
    description = "Module to check whether an IP address or hostname belongs to popular cloud providers";
    homepage = "https://github.com/blacklanternsecurity/cloudcheck";
    changelog = "https://github.com/blacklanternsecurity/cloudcheck/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
