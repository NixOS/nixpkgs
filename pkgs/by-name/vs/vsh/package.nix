{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "vsh";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "fishi0x01";
    repo = "vsh";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-rYltOLDmrRc3KsxR5MmpZqf+loAs1KEdPndpnhqkBDM=";
  };

  # vendor directory is part of repository
  vendorHash = null;

  # make sure version gets set at compile time
  ldflags = [
    "-s"
    "-w"
    "-X main.vshVersion=v${finalAttrs.version}"
  ];

  meta = {
    description = "HashiCorp Vault interactive shell";
    homepage = "https://github.com/fishi0x01/vsh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fishi0x01 ];
    mainProgram = "vsh";
  };
})
