{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "papirus-icon-theme-${version}";
  version = "20170715";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "papirus-icon-theme";
    rev = "${version}";
    sha256 = "0mpmgpjwc7azhypvrlnxaa0c4jc6g7vgy242apxrn8jcv9ndmwyk";
  };

  dontBuild = true;

  installPhase = ''
     install -dm 755 $out/share/icons
     cp -dr Papirus{,-Dark,-Light} $out/share/icons/
     cp -dr ePapirus $out/share/icons/
  '';

  meta = with stdenv.lib; {
    description = "Papirus icon theme for Linux";
    homepage = "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
