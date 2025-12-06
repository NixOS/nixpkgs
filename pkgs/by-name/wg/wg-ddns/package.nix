{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "wg-ddns";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "fernvenue";
    repo = "wg-ddns";
    tag = "v${version}";
    hash = "sha256-1Q6krfFoeSo6XCUt77x7lwDGvIhtx+oJ6cetpf1Tsj8=";
  };

  vendorHash = "sha256-VfSLrWuvJF4XwAW2BQGxh+3v9RiWmPdysw/nIdt2A9M=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A lightweight tool that provides DDNS dynamic DNS support for WireGuard";
    homepage = "https://github.com/fernvenue/wg-ddns";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.bdim404 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "wg-ddns";
  };
}
