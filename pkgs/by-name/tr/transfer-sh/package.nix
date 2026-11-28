{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "transfer-sh";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "dutchcoders";
    repo = "transfer.sh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ktvmzIww9qHVnM85EDN/Z8x6zUzA/yfqI4u63y2rToc=";
  };

  vendorHash = "sha256-nYvzJbfd48S/pMT8bxC2V1xTw6barllNEwcihmefyBM=";

  passthru = {
    tests = {
      inherit (nixosTests) transfer-sh;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Easy and fast file sharing and pastebin server with access from the command-line";
    homepage = "https://github.com/dutchcoders/transfer.sh";
    changelog = "https://github.com/dutchcoders/transfer.sh/releases";
    mainProgram = "transfer.sh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ocfox
      pinpox
    ];
  };
})
