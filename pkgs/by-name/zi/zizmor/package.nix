{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  zizmor,
}:

rustPlatform.buildRustPackage rec {
  pname = "zizmor";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "zizmor";
    tag = "v${version}";
    hash = "sha256-J2pKaGPbRYWlupWHeXbDpxMDpWk+Px0yuKsH6wiFq5M=";
  };

  cargoHash = "sha256-YrQBR5RVBAqYqdAucRiqO8cFmgdVvqA8HEYOXFieSsU=";

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
