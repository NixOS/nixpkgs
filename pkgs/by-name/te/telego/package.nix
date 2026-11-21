{
  buildGo127Module,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

# Telego requires Go 1.27 in go.mod.
buildGo127Module (finalAttrs: {
  pname = "telego";
  version = "0.5.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Scratch-net";
    repo = "telego";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VY8rwxVdJy3x0W547yJBOC/m3XioAC/DZ/iBJONTgE0=";
  };

  vendorHash = "sha256-1DOS0O2lB3ByEp/x+1TwvreBjqA+C8X7W2Ch4jdLZ74=";

  subPackages = [ "cmd/telego" ];

  # Build only the command, but run the complete repository test suite.
  preCheck = ''
    unset subPackages
  '';

  tags = [
    "poll_opt"
    "gc_opt"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    description = "High-performance Telegram MTProxy with TLS fronting and WEB protocol support";
    homepage = "https://github.com/Scratch-net/telego";
    changelog = "https://github.com/Scratch-net/telego/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "telego";
    maintainers = with lib.maintainers; [ scratch-net ];
    platforms = lib.platforms.linux;
  };
})
