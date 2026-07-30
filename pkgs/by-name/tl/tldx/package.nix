{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tldx";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "brandonyoungdev";
    repo = "tldx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3eVVN5PP3MxMSlZK+cASw7twgUZryMdTNOuseoynSZI=";
  };

  vendorHash = "sha256-ApR/XDuOpXiZuyJWEsMbrwYn81Rq9XAYh38fbPoh7rM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/brandonyoungdev/tldx/cmd.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    license = lib.licenses.asl20;
    mainProgram = "tldx";
    description = "Domain availability research tool";
    homepage = "https://github.com/brandonyoungdev/tldx";
    changelog = "https://github.com/brandonyoungdev/tldx/blob/main/CHANGELOG.md";
    maintainers = with lib.maintainers; [ sylonin ];
  };
})
