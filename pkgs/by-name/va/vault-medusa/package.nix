{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "vault-medusa";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "jonasvinther";
    repo = "medusa";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-pMCkJMY5KFkNsmv/LFYZrDmrq2G7fw1fl9HEYGAKuIM=";
  };

  vendorHash = "sha256-+bGuWOFmglvW/qB+6VlOPeoB9lwkikksQPuDKE/2kXw=";

  meta = {
    description = "Cli tool for importing and exporting Hashicorp Vault secrets";
    mainProgram = "medusa";
    homepage = "https://github.com/jonasvinther/medusa";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
})
