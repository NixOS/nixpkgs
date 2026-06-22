{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo126Module (finalAttrs: {
  pname = "thruster";
  version = "0.1.21";

  src = fetchFromGitHub {
    owner = "basecamp";
    repo = "thruster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gFYVbvcXpy03rddB3MbYeT6V1Iex2TtdpC2VeUhO6vo=";
  };

  vendorHash = "sha256-i5u1quR5V0ceFwRDW0Vym+9/dFUwzp9Wc1JrM0KGgY8=";

  subPackages = [ "cmd/thrust" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Zero-config HTTP/2 proxy for Rails applications";
    homepage = "https://github.com/basecamp/thruster";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "thrust";
  };
})
