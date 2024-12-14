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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "zizmor";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ccue+Yt64OA4QkBBKPp/qB6N/qgMyPGpoQFXD1G9fA8=";
  };

  cargoHash = "sha256-TYCfBo3AWbKBIH7S94c/XjHJJHN58qFjNTpidh96jGM=";

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
