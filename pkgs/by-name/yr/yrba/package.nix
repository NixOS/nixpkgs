{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "yrba";
  version = "2.4.0";
  src = fetchFromGitHub {
      owner = "lilith-roth";
      repo = "yrba";
      tag = "v${version}";
      hash = "sha256-yYPctHtAdRiSPJaYyZHcYTB76wpc2z7xBO5fCTRtBxs=";
  };

  cargoTestFlags = [
    # Don't run integration tests, as they require other services to run which are configured in docker
    "--bins"
  ];
  cargoHash = "sha256-/JG9X5nteBUXtngZSnbQ1v6HcuFceoBo7vG4UDbmz50=";
  nativeBuildInputs = [
      pkg-config
  ];
  buildInputs = [
      openssl
  ];
  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  meta = {
    description = "Incremental remote backups made easy!";
    homepage = "https://github.com/lilith-roth/yrba";
    changelog = "https://github.com/lilith-roth/yrba/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ lilith-roth ];
    mainProgram = "yrba";
  };
}
