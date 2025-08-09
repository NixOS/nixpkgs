{
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  lib,
  arp-scan,
}:

buildGoModule rec {
  pname = "watchyourlan";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "aceberg";
    repo = "WatchYourLAN";
    tag = version;
    hash = "sha256-BI/Ydp7YswgdhwaptmqohwCw1gvRefFF9cz3Bjc2cnA=";
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
    changelog = "https://github.com/aceberg/WatchYourLAN/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    mainProgram = "WatchYourLAN";
    maintainers = [ lib.maintainers.iv-nn ];
  };
}
