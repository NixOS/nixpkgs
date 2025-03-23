{
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  lib,
  arp-scan,
}:
buildGoModule rec {
  pname = "watchyourlan";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "aceberg";
    repo = "WatchYourLAN";
    rev = version;
    hash = "sha256-nJYDGCkT8vCkxySLONG3OkWVkaBqXqSFgd7N1TTMAf4=";
  };

  vendorHash = "sha256-urSFoFkYllV+bsKIRV/azkbL30mbGeciYR7jy/fOE/w=";

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
    license = lib.licenses.mit;
    mainProgram = "WatchYourLAN";
    maintainers = [ lib.maintainers.iv-nn ];
  };
}
