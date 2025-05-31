{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule rec {
  pname = "terraform-docs";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "terraform-docs";
    repo = "terraform-docs";
    rev = "v${version}";
    hash = "sha256-DiKoYAe7vcNy35ormKHYZcZrGK/MEb6VmcHWPgrbmUg=";
  };

  vendorHash = "sha256-ynyYpX41LJxGhf5kF2AULj+VKROjsvTjVPBnqG+JGSg=";

  excludedPackages = [ "scripts" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/terraform-docs completion bash >terraform-docs.bash
    $out/bin/terraform-docs completion fish >terraform-docs.fish
    $out/bin/terraform-docs completion zsh >terraform-docs.zsh
    installShellCompletion terraform-docs.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "Utility to generate documentation from Terraform modules in various output formats";
    mainProgram = "terraform-docs";
    homepage = "https://github.com/terraform-docs/terraform-docs/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
