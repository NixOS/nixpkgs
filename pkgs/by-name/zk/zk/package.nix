{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "zk";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "zk-org";
    repo = "zk";
    rev = "v${version}";
    sha256 = "sha256-h4q3GG4DPPEJk2G5JDbUhnHpqEdMAkGYSMs9TS5Goco=";
  };

  vendorHash = "sha256-2PlaIw7NaW4pAVIituSVWhssSBKjowLOLuBV/wz829I=";

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

  meta = with lib; {
    maintainers = with maintainers; [ pinpox ];
    license = licenses.gpl3;
    description = "Zettelkasten plain text note-taking assistant";
    homepage = "https://github.com/mickael-menu/zk";
    mainProgram = "zk";
  };
}
