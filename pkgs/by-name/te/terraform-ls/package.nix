{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "terraform-ls";
  version = "0.38.7";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-ls";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uxdQHfjqthvNqqLjuuQsIPbjSx7STpH4Pmtw1Z2Npy4=";
  };

  vendorHash = "sha256-GVToa/RfXZaKIPWRkCu6rLN8qU3sI6zmgn4kjeNW6iI=";

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
