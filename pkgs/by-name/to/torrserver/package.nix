{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  makeWrapper,
  ffmpeg,
}:
buildGo126Module rec {
  pname = "torrserver";
  version = "143";

  src = fetchFromGitHub {
    owner = "YouROK";
    repo = "TorrServer";
    tag = "MatriX.${version}";
    sha256 = "sha256-JP6fvf2OCz5A495YXzuajzuxh7VDb88WZBz2AuaUEUU=";
  };
  vendorHash = "sha256-l4eaMqh2OeUkr812bLnIF4XjLlnQvPxcvhk0v+4I/gU=";

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
