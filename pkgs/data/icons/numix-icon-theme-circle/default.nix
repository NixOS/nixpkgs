{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "d7e8c4cdcf";

  package-name = "numix-icon-theme-circle";
  
  name = "${package-name}-20150304";

  buildInputs = [ unzip ];
  
  src = fetchurl {
    url = "https://github.com/numixproject/${package-name}/archive/${version}.zip";
    sha256 = "672d6f4d000c4c75a64e0297f9609afab1035d082d7ab4f7abe3e2173cba9324";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Numix-Circle{,-Light} $out/share/icons/
  '';
  
  meta = {
    description = "Numix icon theme (circle version)";
    homepage = https://numixproject.org;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
