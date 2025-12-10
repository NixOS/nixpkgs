{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "undock";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "crazy-max";
    repo = "undock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p4x8SCYLErcu0ACbWUTjZVlzF+QEoC6xS7rpsOno/yw=";
  };

  vendorHash = null;

  tags = [
    "containers_image_openpgp"
    "exclude_graphdriver_btrfs"
    "exclude_graphdriver_devicemapper"
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
