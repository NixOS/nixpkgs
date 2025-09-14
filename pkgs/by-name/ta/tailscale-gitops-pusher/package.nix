{
  lib,
  tailscale,
  buildGo124Module,
}:

buildGo124Module {
  inherit (tailscale)
    version
    src
    vendorHash
    ;
  pname = "tailscale-gitops-pusher";

  env = {
    inherit (tailscale) CGO_ENABLED;
  };

  subPackages = [
    "cmd/gitops-pusher"
  ];

  ldflags = [
    "-w"
    "-s"
    "-X tailscale.com/version.longStamp=${tailscale.version}"
    "-X tailscale.com/version.shortStamp=${tailscale.version}"
  ];

  meta = {
    homepage = "https://tailscale.com";
    description = "Allows users to use a GitOps flow for managing Tailscale ACLs";
    license = lib.licenses.bsd3;
    mainProgram = "gitops-pusher";
    teams = [ lib.teams.cyberus ];
  };
}
