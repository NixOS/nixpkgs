{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  zizmor,
}:

rustPlatform.buildRustPackage rec {
  pname = "zizmor";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "zizmor";
    tag = "v${version}";
    hash = "sha256-LJ/yg5Xm5TIf7fQf84iHJpQ/Zsu0hz5YRPZEZO/eAS4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-AKc4RPdtxr2zcsfUJ/MVF9EId4394SZrP8vx8O35lho=";

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
