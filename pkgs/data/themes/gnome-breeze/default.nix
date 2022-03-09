{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "gnome-breeze";
  version = "unstable-2016-05-26";

  src = fetchFromGitHub {
    owner = "dirruk1";
    repo = "gnome-breeze";
    rev = "49a5cd67a270e13a4c04a4b904f126ef728e9221";
    sha256 = "sha256-lQYVOhFBDOYT+glUHleuymGTfHEE5bIyqUFnS/EDc0I=";
  };

  installPhase = ''
    mkdir -p $out/share/themes
    cp -r Breeze* $out/share/themes
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "A GTK theme built to match KDE's breeze theme";
    homepage = "https://github.com/dirruk1/gnome-breeze";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ bennofs ];
    platforms = platforms.all;
    hydraPlatforms = [];
  };
}
