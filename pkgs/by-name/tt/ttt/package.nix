{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ttt";
  version = "1.10.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eugenioenko";
    repo = "ttt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OM7lZgqOiGIyk+bOnOl95Iy8JKte68Q2gJGaeTb4XB0=";
  };

  vendorHash = "sha256-Rlv/akRDQwbbpGblCaVoWRPQnspg0Ijt7bpm3jYmDeE=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/ttt" ];

  meta = {
    description = "IDE that lives in your terminal";
    homepage = "http://tttedit.dev";
    downloadPage = "https://github.com/eugenioenko/ttt";
    changelog = "https://github.com/eugenioenko/ttt/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "ttt";
  };
})
