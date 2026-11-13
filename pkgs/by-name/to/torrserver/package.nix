{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  ffmpeg,
}:
buildGoModule rec {
  pname = "torrserver";
  version = "150";

  src = fetchFromGitHub {
    owner = "YouROK";
    repo = "TorrServer";
    tag = "MatriX.${version}";
    sha256 = "sha256-d/uRWZWCz5aQpSNHDJM1vnLtNxAY0AXUCITWFHg99H8=";
  };
  vendorHash = "sha256-x67fp19mWBEQUcR+QWyP4MFNVzHqeM9P20xz+H687kM=";

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
