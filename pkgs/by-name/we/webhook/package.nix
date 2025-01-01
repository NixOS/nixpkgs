{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "webhook";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "adnanh";
    repo = "webhook";
    rev = version;
    sha256 = "sha256-3Ew72ADGTlvp6w37nYbCng7HHCZ0a7kVf3DNRNyCkZU=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  doCheck = false;

  passthru.tests = { inherit (nixosTests) webhook; };

  meta = with lib; {
    description = "Incoming webhook server that executes shell commands";
    mainProgram = "webhook";
    homepage = "https://github.com/adnanh/webhook";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
