{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "tint";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "ashish0kumar";
    repo = "tint";
    tag = "v${version}";
    hash = "sha256-TZYAcs6h4Fv0XpUqzgCcAF5cHGaVKMMCJ6MTAH6C6Jo=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Command-line tool to recolor images using theme palettes";
    homepage = "https://github.com/ashish0kumar/tint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashish0kumar ];
    mainProgram = "tint";
    platforms = lib.platforms.unix;
  };
}
