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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "zizmor";
    rev = "v${version}";
    hash = "sha256-3W5S49eHZZfKXTI2xdB32kLoTnCVKYtwLbJwempnXCc=";
  };

  cargoHash = "sha256-ZCCmdnSj6u+k+dRUHFyKuDvnVNBtMAkmcz6TMQ1i7zs=";

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
