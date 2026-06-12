{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  makeWrapper,
  ffmpeg,
}:
buildGo126Module rec {
  pname = "torrserver";
  version = "141.5";

  src = fetchFromGitHub {
    owner = "YouROK";
    repo = "TorrServer";
    tag = "MatriX.${version}";
    sha256 = "sha256-f1D6ZeIa5Uw6I/dG4OCN2ZbRudftaMlgQx+NuQVTWIA=";
  };
  vendorHash = "sha256-AHkSemWYa4w20YKUyfhD1Liw9AwbgCxq+UmqVW0G70g=";

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
