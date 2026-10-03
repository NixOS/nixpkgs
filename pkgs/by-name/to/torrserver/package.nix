{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  makeWrapper,
  ffmpeg,
}:
buildGo126Module rec {
  pname = "torrserver";
  version = "145";

  src = fetchFromGitHub {
    owner = "YouROK";
    repo = "TorrServer";
    tag = "MatriX.${version}";
    hash = "sha256-6ZqauoQ368gvuBfNYGsmnzA2bbbUOX7XoIVRlf6u3yI=";
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
