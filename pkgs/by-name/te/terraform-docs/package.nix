{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule rec {
  pname = "terraform-docs";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "terraform-docs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NOI9/2zGimsHMvdi2lGwl6YLVGpOET6g9C/l0xUZ/pI=";
  };

  vendorHash = "sha256-/56Y3VE4h//8IlyP8ocMFiorgw/4ee32J5FQYxFCIU8=";

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
