{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "terraform-ls";
  version = "0.39.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-ls";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9h5DqKZrs0MBEhCk8Bwt3pxK9+bSMUzWseH2BIrMwc4=";
  };

  vendorHash = "sha256-jk0xaiFxGUbR7SlXvWezpmjhxK19mK7OLdAfRQviFgs=";

  ldflags = [
    "-s"
    "-w"
  ];

  # There's a mixture of tests that use networking and several that fail on aarch64
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/terraform-ls --help
    $out/bin/terraform-ls --version | grep "${finalAttrs.version}"
    runHook postInstallCheck
  '';

  meta = {
    description = "Terraform Language Server (official)";
    mainProgram = "terraform-ls";
    homepage = "https://github.com/hashicorp/terraform-ls";
    changelog = "https://github.com/hashicorp/terraform-ls/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      mbaillie
      jk
    ];
  };
})
