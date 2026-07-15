{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weathr";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "veirt";
    repo = "weathr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BaG8K17RNuswtGx74CEBzMKjFMaNW0RZ5FjM3EfSVTE=";
  };

  cargoHash = "sha256-xIjFleANgzoTS+4Yky+mvtX1IeU6IdaH1YuB8W8bYIo=";

  # These test fail due to internet access requirement
  checkFlags = [
    "--skip=test_cache_invalidation"
    "--skip=test_weather_client_integration_cache_behavior"
    "--skip=test_weather_client_integration_cache_invalidation"
    "--skip=test_weather_client_integration_realistic_weather_ranges"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Terminal weather app with ascii animation";
    homepage = "https://github.com/veirt/weathr";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [
      sudo-mac
      phanirithvij
    ];
    mainProgram = "weathr";
  };
})
