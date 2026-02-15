{
  lib,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weathr";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Veirt";
    repo = "weathr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JwI5a+O5Nu39Nr0st5yBLTM5kPLC8UIGAoBMqxnOOl4=";
  };

  cargoHash = "sha256-Yj1WxpOLL8GiVpCebPZQgdw+L9g+4CNY7n2z8PJQz4k=";

  nativeBuildInputs = [ pkg-config ];

  checkFlags = [
    # network dependent tests
    "--skip=weather_client_integration_test"
    "--skip=test_cache_invalidation"
    "--skip=test_weather_client_integration_realistic_weather_ranges"
    "--skip=test_weather_client_integration_cache_behavior"
    "--skip=test_weather_client_integration_cache_invalidation"
  ];

  meta = {
    changelog = "https://github.com/Veirt/weathr/releases/tag/v${finalAttrs.version}";
    description = "Terminal weather app with ASCII animations driven by real-time weather data";
    homepage = "https://github.com/Veirt/weathr";
    license = lib.licenses.mit;
    mainProgram = "weathr";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
