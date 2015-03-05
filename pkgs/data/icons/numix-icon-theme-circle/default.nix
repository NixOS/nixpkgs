{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "d7e8c4cdcf";

  package-name = "numix-icon-theme-circle";
  
  name = "${package-name}-${version}";

  buildInputs = [ unzip ];
  
  src = fetchurl {
    url = "https://github.com/numixproject/${package-name}/archive/${version}.zip";
    sha256 = "672d6f4d000c4c75a64e0297f9609afab1035d082d7ab4f7abe3e2173cba9324";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/usr/share/icons
    cp -dr --no-preserve='ownership' Numix-Circle{,-Light} $out/usr/share/icons/
  '';
  
  meta = {
    description = "Numix icon theme (circle version)";
    homepage = https://numixproject.org;
    platforms = stdenv.lib.platforms.linux;
  };
}
