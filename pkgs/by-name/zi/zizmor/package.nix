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
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "zizmor";
    rev = "refs/tags/v${version}";
    hash = "sha256-bQpjU3ztaO8Fckk51QGOnJFANXceYwiqyopOzMt6UYM=";
  };

  cargoHash = "sha256-IzTXLwh14v4vjNgl37sFe1hgoA+0Izc9QWelaaArgU4=";

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
