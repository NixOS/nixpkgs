{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "toml-test";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "toml-lang";
    repo = "toml-test";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jOFkSEDNvvx8svgyYYpAbveQsclMsQRKJ2ocA6ty1Kw=";
  };

  vendorHash = "sha256-yt5rwpYzO38wEUhcyG4G367Byek20Uz3u+buAazq/5A=";

  ldflags = [
    "-s"
    "-w"
    "-X zgo.at/zli.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language agnostic test suite for TOML parsers";
    homepage = "https://github.com/toml-lang/toml-test";
    changelog = "https://github.com/toml-lang/toml-test/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      yzx9
      defelo
    ];
    mainProgram = "toml-test";
  };
})
