{
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  lib,
  arp-scan,
}:
buildGoModule rec {
  pname = "watchyourlan";
  version = "2.0.1";

  vendorHash = "sha256-+7CMubbCrl+DsGmN9/2jCQ6zLDKvjJ6PdJx8iI1vKOQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postFixup = ''
    wrapProgram $out/bin/WatchYourLAN \
      --prefix PATH : '${lib.makeBinPath [ arp-scan ]}'
  '';

  src = fetchFromGitHub {
    owner = "aceberg";
    repo = "WatchYourLAN";
    rev = version;
    hash = "sha256-dPmtUv1alhwkrRrEVJ8cIi4BVVGz2tJu//Mdddx8zDs=";
  };

  meta = {
    description = "Lightweight network IP scanner with web GUI";
    homepage = "https://github.com/aceberg/WatchYourLAN";
    license = lib.licenses.mit;
    mainProgram = "WatchYourLAN";
    maintainers = [ lib.maintainers.iv-nn ];
  };
}
