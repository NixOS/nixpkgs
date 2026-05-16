{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "terraform-lsp";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "juliosueiras";
    repo = "terraform-lsp";
    rev = "v${finalAttrs.version}";
    sha256 = "111350jbq0dp0qhk48j12hrlisd1fwzqpcv357igrbqf6ki7r78q";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.GitCommit=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "Language Server Protocol for Terraform";
    mainProgram = "terraform-lsp";
    homepage = "https://github.com/juliosueiras/terraform-lsp";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
