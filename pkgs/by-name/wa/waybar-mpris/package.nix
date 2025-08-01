{
  lib,
  fetchgit,
  buildGoModule,
  nix-update-script,
}:

buildGoModule {
  pname = "waybar-mpris";
  version = "0.1.0-unstable-2022-01-27";

  src = fetchgit {
    url = "https://git.hrfee.pw/hrfee/waybar-mpris";
    rev = "485ec0ec0af80a0d63c10e94aebfc59b16aab46b";
    hash = "sha256-BjLxWnDNsR2ZnNklNiKzi1DeoPpaZsRdKbVSwNwYhJ4=";
  };

  vendorHash = "sha256-85jFSAOfNMihv710LtfETmkKRqcdRuFCHVuPkW94X/Y=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = with lib; {
    description = "Waybar component/utility for displaying and controlling MPRIS2 compliant media players individually";
    homepage = "https://git.hrfee.pw/hrfee/waybar-mpris";
    license = licenses.mit;
    mainProgram = "waybar-mpris";
    maintainers = with maintainers; [ khaneliman ];
  };
}
