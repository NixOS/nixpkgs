{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
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

  postPatch = ''
    substituteInPlace webhook_test.go \
      --replace-fail '/bin/echo' 'echo'
  '';

  vendorHash = null;

  subPackages = [ "." ];

  passthru.tests = { inherit (nixosTests) webhook; };

  meta = {
    description = "Incoming webhook server that executes shell commands";
    mainProgram = "webhook";
    homepage = "https://github.com/adnanh/webhook";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.quantenzitrone ];
  };
})
