{ stdenv, fetchFromGitHub, unzip }:

stdenv.mkDerivation rec {
  version = "129da4d8036c9ea52ba8b94cdfa0148e4c2cff96";

  package-name = "numix-icon-theme-circle";
  
  name = "${package-name}-20151014";

  buildInputs = [ unzip ];
  
  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "1505j63qh96hy04x3ywc6kspavzgjd848cgdkda23kjdbx0fpij4";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Numix-Circle{,-Light} $out/share/icons/
  '';
  
  meta = with stdenv.lib; {
    description = "Numix icon theme (circle version)";
    homepage = https://numixproject.org;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jgeerds ];
  };
}
