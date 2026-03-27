{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "typer";
  version = "0-unstable-2024-05-25";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "typer";
    rev = "0e674b236154b05f89fb4f5bee20c7269fd71477";
    hash = "sha256-tldLNSNYhPictiCyplxYxScyimcb5tMR3hdwhdZxrAA=";
  };

  vendorHash = "sha256-t4zim6WhqGAf1zHmmbJbpVvQcE/aoNL7ZLdjU7f3rp8=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Typing test in your terminal";
    homepage = "https://github.com/maaslalani/typer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "typer";
  };
}
