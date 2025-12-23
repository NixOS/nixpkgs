{
  lib,
  tailscale,
  buildGoModule,
}:

buildGoModule {
  pname = "tailscale-gitops-pusher";
  inherit (tailscale) version;

  # It's hosted in the `tailscale` monorepo.
  inherit (tailscale) src vendorHash;

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
