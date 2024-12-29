{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  testers,
  zizmor,
}:

rustPlatform.buildRustPackage rec {
  pname = "zizmor";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "zizmor";
    rev = "refs/tags/v${version}";
    hash = "sha256-fq+J1+CrxFSbCimM8SIshwQciEjRjPcjAmdVKbVV13s=";
  };

  cargoHash = "sha256-OUwl9vBB8jMY40SbOc9YK4yyxvgWQTgQRWw2LN07W08=";

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  passthru.tests.version = testers.testVersion {
    package = zizmor;
  };

  meta = {
    description = "Tool for finding security issues in GitHub Actions setups";
    homepage = "https://woodruffw.github.io/zizmor/";
    changelog = "https://github.com/woodruffw/zizmor/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lesuisse ];
    mainProgram = "zizmor";
  };
}
