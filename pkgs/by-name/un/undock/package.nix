{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "undock";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "crazy-max";
    repo = "undock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QL4HcC8Tkbp6UQ/UuShfV2LlYCAhj4UnL8BvdpeRH0U=";
  };

  vendorHash = null;

  tags = [
    "containers_image_openpgp"
    "exclude_graphdriver_btrfs"
    "exclude_graphdriver_devicemapper"
    # On Go 1.27 the vendored x/net v0.54.0 wraps the standard library's
    # HTTP/2, which lacks http2.TrailerPrefix, so the vendored grpc v1.80.0
    # fails to compile. http2legacy keeps x/net's own implementation.
    "http2legacy" # fix for v0.14.1 - upstream main branch already has the fix
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/undock
  '';

  meta = {
    description = "Extract contents of a container image in a local folder";
    homepage = "https://crazymax.dev/undock/";
    license = lib.licenses.mit;
    mainProgram = "undock";
    maintainers = with lib.maintainers; [
      nolith
    ];
  };
})
