{
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  lib,
  arp-scan,
}:

buildGoModule rec {
  pname = "watchyourlan";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "aceberg";
    repo = "WatchYourLAN";
    tag = version;
    hash = "sha256-TFqBuJHoHKJ/ftorgNG9JpiOrjSmqw+tHhaOYzoTeUM=";
  };

  vendorHash = "sha256-3HxpKahFa8keM9wbNJ3anEBMCoEphaj5rOhydajtnY0=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postFixup = ''
    wrapProgram $out/bin/WatchYourLAN \
      --prefix PATH : '${lib.makeBinPath [ arp-scan ]}'
  '';

  meta = {
    description = "Lightweight network IP scanner with web GUI";
    homepage = "https://github.com/aceberg/WatchYourLAN";
    changelog = "https://github.com/aceberg/WatchYourLAN/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    mainProgram = "WatchYourLAN";
    maintainers = [ lib.maintainers.iv-nn ];
  };
}
