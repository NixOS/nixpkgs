{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo126Module (finalAttrs: {
  pname = "thruster";
  version = "0.1.25";

  src = fetchFromGitHub {
    owner = "basecamp";
    repo = "thruster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cwAYWl8MnrR3z8OLI12DgFgBj+7muJagayzC6sX+g30=";
  };

  vendorHash = "sha256-V9KAr+/r5SGNSBamD3U7bvBiiXn5GTmopSxiNmFL6lQ=";

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
