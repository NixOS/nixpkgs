{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  ffmpeg,
}:
buildGoModule rec {
  pname = "torrserver";
  version = "136.2.NE";

  src = fetchFromGitHub {
    owner = "YouROK";
    repo = "TorrServer";
    rev = "MatriX.${version}";
    sha256 = "sha256-hjOsgQJ2YX+FnE1zzglwr4IjtHAHOxTB/pLo/6aMQRo=";
  };
  vendorHash = "sha256-wC7rVAWB5yi86vRDodL+xl153fhKstby6f/Q6SUlSUU=";

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
