{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "vsh";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "fishi0x01";
    repo = "vsh";
    rev = "v${version}";
    sha256 = "083rqca4gx9lmzkc9rl453zqmspbpn0h2vajkrjjcwk96km7064f";
  };

  # vendor directory is part of repository
  vendorHash = null;

  # make sure version gets set at compile time
  ldflags = [
    "-s"
    "-w"
    "-X main.vshVersion=v${version}"
  ];

  meta = with lib; {
    description = "HashiCorp Vault interactive shell";
    homepage = "https://github.com/fishi0x01/vsh";
    license = licenses.mit;
    maintainers = with maintainers; [ fishi0x01 ];
    mainProgram = "vsh";
  };
}
