{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "webhook";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "adnanh";
    repo = "webhook";
    tag = finalAttrs.version;
    hash = "sha256-P+uLVv0YMlTXrbWVapXRXc+VvQZxUiimLG0EX9tDxpM=";
  };

  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace webhook_test.go \
      --replace-fail '/bin/echo' 'echo'
  '';

  vendorHash = null;

  subPackages = [ "." ];

  passthru = {
    tests = { inherit (nixosTests) webhook; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Incoming webhook server that executes shell commands";
    mainProgram = "webhook";
    homepage = "https://github.com/adnanh/webhook";
    changelog = "https://github.com/adnanh/webhook/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.quantenzitrone ];
  };
})
