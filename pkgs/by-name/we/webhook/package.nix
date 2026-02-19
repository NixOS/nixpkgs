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
    rev = finalAttrs.version;
    sha256 = "sha256-P+uLVv0YMlTXrbWVapXRXc+VvQZxUiimLG0EX9tDxpM=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  doCheck = false;

  passthru.tests = { inherit (nixosTests) webhook; };

  meta = {
    description = "Incoming webhook server that executes shell commands";
    mainProgram = "webhook";
    homepage = "https://github.com/adnanh/webhook";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ azahi ];
  };
})
