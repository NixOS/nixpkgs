{
  lib,
  tailscale,
  buildGoModule,
}:

buildGoModule {
  pname = "tailscale-gitops-pusher";
  __structuredAttrs = true;

  # It's hosted in the `tailscale` monorepo.
  inherit (tailscale)
    version
    src
    vendorHash
    ldflags
    env
    ;

  subPackages = [
    "cmd/gitops-pusher"
  ];

  meta = (tailscale.meta or { }) // {
    description = "Allows users to use a GitOps flow for managing Tailscale ACLs";
    mainProgram = "gitops-pusher";
    maintainers = with lib.maintainers; [
      e1mo
      xanderio
    ];
  };
}
