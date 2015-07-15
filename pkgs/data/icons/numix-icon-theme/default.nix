{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2c11fbfcee";

  package-name = "numix-icon-theme";

  name = "${package-name}-20150302";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "1bjh2j4vqk9s31syv7ig3hwpp5z0n6sx74iz332y0wdz6ngj5x08";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Numix{,-Light} $out/share/icons/
  '';

  meta = {
    description = "Numix icon theme";
    homepage = https://numixproject.org;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
