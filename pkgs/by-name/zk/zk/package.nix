{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "zk";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "zk-org";
    repo = "zk";
    rev = "v${version}";
    sha256 = "sha256-WbFx+teAjLeY/nEIhbW5zQS70cekQbBHsrp1lO1Wwkc=";
  };

  vendorHash = "sha256-g4l14CCn+pFqVT22pzL2cocqOtQbsOI9W1OlpecUtBo=";

  doCheck = false;

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Build=${version}"
    "-X=main.Version=${version}"
  ];

  passthru.updateScript = nix-update-script { };

  tags = [ "fts5" ];

  meta = {
    maintainers = with lib.maintainers; [ pinpox ];
    license = lib.licenses.gpl3;
    description = "Zettelkasten plain text note-taking assistant";
    homepage = "https://github.com/mickael-menu/zk";
    mainProgram = "zk";
  };
}
