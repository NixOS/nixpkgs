{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo126Module (finalAttrs: {
  pname = "thruster";
  version = "0.1.22";

  src = fetchFromGitHub {
    owner = "basecamp";
    repo = "thruster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d+zdzzT+47y9WOFARlQ/wCrc9tnyS/4HsE0a6aQl/KA=";
  };

  vendorHash = "sha256-veXgGs6+TauExVAaNnkIZwylQWZ4um3rrG8of/dYCv0=";

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
