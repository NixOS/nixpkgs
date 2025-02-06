{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  zizmor,
}:

rustPlatform.buildRustPackage rec {
  pname = "zizmor";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "zizmor";
    tag = "v${version}";
    hash = "sha256-yETJh0fSTPGVZV7sdQl+ARbHImJ5n5w+R9kumu7n0Ww=";
  };

  cargoHash = "sha256-QkR5PCJr9y0kVSIhqPsOn7xX0m6kr2wOwBroIEZUhAk=";

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
