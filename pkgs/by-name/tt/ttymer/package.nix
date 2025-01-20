{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "ttymer";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "darwincereska";
    repo = "ttymer";
    tag = "v${version}";
    hash = "sha256-5XknyjZXlOPPUspz3XdAsp2PVb0Jtk1rDjD6SnXVQbw=";

  };

  vendorHash = null;

  meta = {
    description = "Simple command line timer for linux written in go";
    homepage = "https://github.com/darwincereska/ttymer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ darwincereska ];
  };
}
