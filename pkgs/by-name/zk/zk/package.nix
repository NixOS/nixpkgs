{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "zk";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "zk-org";
    repo = "zk";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-9lqXlu9RM3AM3Y0GMBUSrRqXx+kd9yDP2Zk0CtLbBq0=";
  };

  vendorHash = "sha256-YX+voBRKC/2LN7ByS8XWgJkm6dAip8L0kHpt754wHck=";

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
    homepage = "https://github.com/mickael-menu/zk";
    mainProgram = "zk";
  };
})
