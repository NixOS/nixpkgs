{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "typtea";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "ashish0kumar";
    repo = "typtea";
    tag = "v${version}";
    hash = "sha256-3mqUHX/EiRGYVCutnzrXYx7C67CVpawNjokVzvMJBYU=";
  };

  vendorHash = "sha256-LWY1Tnh4iyNAV7dNjlKdT9IwPJRN25HkEAGSkQIRe9I=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ashish0kumar/typtea/cmd.version=${version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    changelog = "https://github.com/ashish0kumar/typtea/releases/tag/v${version}";
    description = "Terminal-based typing speed test with multi-language support";
    homepage = "https://github.com/ashish0kumar/typtea";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashish0kumar ];
    mainProgram = "typtea";
    platforms = lib.platforms.unix;
  };
}
