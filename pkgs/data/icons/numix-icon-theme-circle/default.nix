{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2016-05-25";

  package-name = "numix-icon-theme-circle";
  
  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "e2d2fe68e34e1650584f798c3cdb7e91ef62e6d3";
    sha256 = "0fah812ymc6kczjhjsz0ai57ih6d8r6pknhvc54i7r3xqxshryc8";
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
