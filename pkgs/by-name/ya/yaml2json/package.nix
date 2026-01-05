{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "yaml2json";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "bronze1man";
    repo = "yaml2json";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mIjtR1VsSeUhEgeSKDG0qT0kj+NCqVwn31m300cMDeU=";
  };

  vendorHash = "sha256-g+yaVIx4jxpAQ/+WrGKxhVeliYx7nLQe/zsGpxV4Fn4=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/bronze1man/yaml2json";
    changelog = "https://github.com/bronze1man/yaml2json/releases/tag/v${finalAttrs.version}";
    description = "Convert yaml to json";
    mainProgram = "yaml2json";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
  };
})
