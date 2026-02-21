{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "talm";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "cozystack";
    repo = "talm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I3rSpFCNMoA5tAp3WVLM6Ae7Vo8m+9px9fg7Fgw0/oA=";
  };

  vendorHash = "sha256-jDp1WVETDbCtSq+v0BrIiTqoR2cnmI7JXdy5ydnt5wA=";

  nativeBuildInputs = [ installShellFiles ];

  # go.mod requires 1.25.6 but nixpkgs has 1.25.5
  preBuild = ''
    substituteInPlace go.mod --replace-fail "go 1.25.6" "go 1.25.5"
  '';

  ldflags = [
    "-s"
    "-X main.Version=v${finalAttrs.version}"
  ];

  # Skip DNS test that fails in sandbox
  checkFlags = [ "-skip=^TestRenderWithDNS$" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd talm \
      --bash <($out/bin/talm completion bash) \
      --fish <($out/bin/talm completion fish) \
      --zsh <($out/bin/talm completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage Talos Linux the GitOps way";
    homepage = "https://github.com/cozystack/talm";
    changelog = "https://github.com/cozystack/talm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kitsunoff ];
    mainProgram = "talm";
  };
})
