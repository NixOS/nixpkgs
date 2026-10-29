{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  makeWrapper,
  ffmpeg,
}:
buildGo126Module rec {
  pname = "torrserver";
  version = "141";

  src = fetchFromGitHub {
    owner = "YouROK";
    repo = "TorrServer";
    tag = "MatriX.${version}";
    sha256 = "sha256-OeAAYyxfZxcx0ANeRAWJTrZMNWtdrM/pwXyO5QNTwYo=";
  };
  vendorHash = "sha256-rjdE9yf6S3ZovEeRO0+5sJsy9PRdFFejFDhkgJLMz58=";

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
