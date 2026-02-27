{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "tdl";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "iyear";
    repo = "tdl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EYS4EK0NmNHnvjMkf5AHrYpZeGw+n2ovFDLanbqpF4Y=";
  };

  vendorHash = "sha256-GpqgH23eK0h2BYxjN5TNUWEOT72smYdUoD1Iy6L2jL4=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/iyear/tdl/pkg/consts.Version=${finalAttrs.version}"
  ];

  # Filter out the main executable
  subPackages = [ "." ];

  # Requires network access
  doCheck = false;

  meta = {
    description = "Telegram downloader/tools written in Golang";
    homepage = "https://github.com/iyear/tdl";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ Ligthiago ];
    mainProgram = "tdl";
  };
})
