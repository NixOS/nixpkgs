{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "2c11fbfcee";

  package-name = "numix-icon-theme";
  
  name = "${package-name}-${version}";

  buildInputs = [ unzip ];
  
  src = fetchurl {
    url = "https://github.com/numixproject/${package-name}/archive/${version}.zip";
    sha256 = "61dc170b8a70b20a9075f06e1668d6bd8907a6db0ef9e3568c473296d0f351e1";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/usr/share/icons
    cp -dr --no-preserve='ownership' Numix{,-Light} $out/usr/share/icons/
  '';
  
  meta = {
    description = "Numix icon theme";
    homepage = https://numixproject.org;
    platforms = stdenv.lib.platforms.linux;
  };
}
