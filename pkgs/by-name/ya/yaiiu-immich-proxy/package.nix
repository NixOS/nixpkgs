{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "yaiiu-immich-proxy";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "FawenYo";
    repo = "YAIIU";
    tag = "v${version}";
    hash = "sha256-uVOSszp2oKtzFCGb9nWdLPqucWavM9dcg6Ba7HR8NfQ=";
  };

  sourceRoot = "${src.name}/immich-proxy";

  vendorHash = null;

  postFixup = ''
    mv $out/bin/immich-proxy $out/bin/yaiiu-immich-proxy
  '';

  meta = {
    homepage = "https://github.com/FawenYo/YAIIU/tree/main/immich-proxy";
    description = "A proxy server that sits between iOS background upload extension and Immich server, handling conversion to the format required by Immich API.";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.luNeder ];
    mainProgram = "yaiiu-immich-proxy";
  };
}
