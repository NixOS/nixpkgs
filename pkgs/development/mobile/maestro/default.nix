{ lib, stdenv, fetchurl, unzip, makeWrapper, jre_headless }:

stdenv.mkDerivation rec {
  pname = "maestro";
  version = "1.15.0";

  src = fetchurl {
    url = "https://github.com/mobile-dev-inc/maestro/releases/download/cli-${version}/maestro.zip";
    sha256 = "1rv9481pffd27ksqdm6z809sa1c5cslxvq53bw04iqgwvhdjzm2m";
  };

  dontUnpack = true;
  nativeBuildInputs = [ unzip makeWrapper ];

  installPhase = ''
    mkdir $out
    unzip $src -d $out
    mv $out/maestro/* $out
    rm -rf $out/maestro
  '';

  postFixup = ''
    wrapProgram $out/bin/maestro --prefix PATH : "${lib.makeBinPath [ jre_headless ]}"
  '';

  meta = with lib; {
    description = "Mobile UI Automation tool";
    homepage = "https://maestro.mobile.dev/";
    license = licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with maintainers; [ SubhrajyotiSen ];
  };
}
