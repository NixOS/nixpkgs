{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "ttymer";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "darwincereska";
    repo = "ttymer";
    tag = "v${version}";
    hash = "sha256-a3+TAGBz1br2TCu9FxtUN4G3H84NZwwV/fFg5/HbJ2k=";

  };

  vendorHash = null;

  meta = {
    description = "Simple command line timer for linux written in go";
    homepage = "https://github.com/darwincereska/ttymer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ darwincereska ];
  };
}
