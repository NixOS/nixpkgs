{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  ffmpeg,
}:
buildGoModule rec {
  pname = "torrserver";
  version = "145.2";

  src = fetchFromGitHub {
    owner = "YouROK";
    repo = "TorrServer";
    tag = "MatriX.${version}";
    sha256 = "sha256-99pDGu9BXCZzFdfE7IDh1V0tsgI9fhbYk8G4v6dX6PE=";
  };
  vendorHash = "sha256-CbyYyHh9IkjHVkqUzTbL1v0i6t6dox+xcrnsQCOxnUQ=";

  modRoot = "server";
  subPackages = [ "cmd" ];
  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/torrserver

    wrapProgram $out/bin/torrserver \
      --set PATH ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = {
    description = "Simple and powerful tool for streaming torrents";
    homepage = "https://github.com/YouROK/TorrServer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ r4v3n6101 ];
  };
}
