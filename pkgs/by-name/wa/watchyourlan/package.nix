{
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  lib,
  arp-scan,
}:
buildGoModule rec {
  pname = "watchyourlan";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "aceberg";
    repo = "WatchYourLAN";
    rev = version;
    hash = "sha256-AJXQmS4MJ+8fzI4WWVCXKAoouGcZX0/XreOmQgLd8X8=";
  };

  vendorHash = "sha256-NUv90wq3nFHDtfk3BitwJ3ZfciPESUIDzS5S/6zafEQ=";

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
