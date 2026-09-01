{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "zk";
  version = "0.15.6";

  src = fetchFromGitHub {
    owner = "zk-org";
    repo = "zk";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-owHbrQwoQS+SbfZ6EQO/ii10zX73MmUpohuIIltlnw8=";
  };

  vendorHash = "sha256-Y5KI3o4HYWyqQl/RnOetyIKOI+CbYWSgrbkGkpAKsX4=";

  doCheck = false;

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Build=${finalAttrs.version}"
    "-X=main.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  tags = [ "fts5" ];

  meta = {
    maintainers = with lib.maintainers; [ pinpox ];
    license = lib.licenses.gpl3;
    description = "Zettelkasten plain text note-taking assistant";
    homepage = "https://github.com/zk-org/zk";
    mainProgram = "zk";
  };
})
