{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sync-io";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "KhushalJangid";
    repo = "sync.io";
    rev = version;
    hash = "sha256-MfUGAlZIMw41LoRz7H+UZbZcv5YtlsmQjba/P/L99LA=";
  };

  vendorHash = "sha256-X4wIeVLp1yHsWsQqaIsQZe9jRgRvSIeYSVDFPcafpTs=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "HTTP based file sharing server to aid platform independent wireless file sharing between multiple devices";
    homepage = "https://github.com/KhushalJangid/sync.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "Sync.io";
  };
}
