{ lib
, tailscale
, buildGoModule
}:

buildGoModule {
  inherit (tailscale) version src vendorHash CGO_ENABLED;
  pname = "tailscale-gitops-pusher";

  subPackages = [
    "cmd/gitops-pusher"
  ];

  ldflags = [
    "-w"
    "-s"
    "-X tailscale.com/version.longStamp=${tailscale.version}"
    "-X tailscale.com/version.shortStamp=${tailscale.version}"
  ];

  meta = with lib; {
    homepage = "https://tailscale.com";
    description = "Allows users to use a GitOps flow for managing Tailscale ACLs";
    license = licenses.bsd3;
    mainProgram = "gitops-pusher";
    maintainers = with maintainers; [ xanderio ];
  };
}
