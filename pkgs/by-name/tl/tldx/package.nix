{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tldx";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "brandonyoungdev";
    repo = "tldx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KLVxt7/bX8EEfKAnSyoCghNJX9uj16SRVl3urUzxGKg=";
  };

  vendorHash = "sha256-uikVWlPKslfpjJ2w6mDI6rc8/Md1jrcABcj9yjkilYw=";

  ldflags = [
    "-s"
    "-X=github.com/brandonyoungdev/tldx/cmd.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    description = "Domain availability research tool";
    homepage = "https://github.com/brandonyoungdev/tldx";
    changelog = "https://github.com/brandonyoungdev/tldx/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sylonin ];
    mainProgram = "tldx";
  };
})
