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
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "zizmor";
    rev = "v${version}";
    hash = "sha256-S2B4GQAqx4t9AZf3QDUhzku68j0buZdW0cLhmOiRssk=";
  };

  cargoHash = "sha256-hoZXR+zYuK/r4/r3QwIhTmMTCs5M0lMACH4QPEq07ZU=";

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
