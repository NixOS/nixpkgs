{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "togo";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "prime-run";
    repo = "togo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7dlari3pjk/DXVwsdeHNbkulo6MlraRlFTMw5xHxxJk=";
  };

  vendorHash = "sha256-WXQXJrpsFDtJ081cSUOu2pAS2S+bT+3fS4Cyb9qFfCk=";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast and simple CLI/TUI task and todo manager";
    longDescription = ''
      togo is a command line task/todo management utility designed to
      be simple, fast, and easy to use.
    '';
    homepage = "https://github.com/prime-run/togo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "togo";
  };
})
