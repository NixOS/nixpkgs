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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "zizmor";
    rev = "v${version}";
    hash = "sha256-dYM8Zkri0H/olODF2weOqdVg1NcPltzu1PZ92IbGLVE=";
  };

  cargoHash = "sha256-18DWe1MHABz1SMg72NcYTSCGvevchqZ3asb8+lg5MwE=";

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
