{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2016-05-18";

  package-name = "numix-icon-theme-circle";
  
  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "11a343dcd9b95e2574706157ff7bfe9aa30441d2";
    sha256 = "0d00fj0hmqchm12j89s1r11ayg7gh8p6cn4fd7zva5n52z35az1w";
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
