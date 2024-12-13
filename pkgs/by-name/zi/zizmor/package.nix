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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "zizmor";
    rev = "refs/tags/v${version}";
    hash = "sha256-NNPY73G1DNxN6D/h73teldF8m1sObP0BufRRtlFI0xo=";
  };

  cargoHash = "sha256-I8kKSIRYLbSFGUNGXmBA1UfgJeMXZgBCKDTnqXkTJcE=";

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
