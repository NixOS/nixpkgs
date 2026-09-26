{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  makeWrapper,
  ffmpeg,
}:
buildGo126Module rec {
  pname = "torrserver";
  version = "144.4";

  src = fetchFromGitHub {
    owner = "YouROK";
    repo = "TorrServer";
    tag = "MatriX.${version}";
    sha256 = "sha256-R4aZE5eSslBS3kWSwo0W6rIdubmrJ2CCeElz1jYAt34=";
  };
  vendorHash = "sha256-/xlC2+aj07dNMz187z3bje+uHoIm7QuCPNwBUDQKBhI=";

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
