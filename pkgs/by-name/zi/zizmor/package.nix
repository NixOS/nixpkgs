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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "zizmor";
    rev = "v${version}";
    hash = "sha256-fZD8wXKS8bGh6P+KS2VM3pCuEDIEeNrK5iAykxzC/2Q=";
  };

  cargoHash = "sha256-n9VLK9i7YayiLD8pnEns19vbtlEktjFutYoKwpXgBCw=";

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
