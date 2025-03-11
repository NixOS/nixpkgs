{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

let
  version = "0.5.0";
in
buildGoModule {
  pname = "yoink";
  inherit version;

  src = fetchFromGitHub {
    owner = "MrMarble";
    repo = "yoink";
    rev = "v${version}";
    hash = "sha256-9ftlAECywF4khH279h2qcSvKRDQX2I7GDQ7EYcEybL0=";
  };

  vendorHash = "sha256-cnfh2D/k4JP9BNlI+6FVLBFyk5XMIYG/DotUdAZaY0Q=";

  meta = {
    homepage = "https://github.com/MrMarble/yoink";
    description = "Automatically download freeleech torrents";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hogcycle ];
  };
}
