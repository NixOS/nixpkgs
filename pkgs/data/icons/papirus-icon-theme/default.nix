{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  name = "papirus-icon-theme-${version}";
  version = "20190203";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "papirus-icon-theme";
    rev = version;
    sha256 = "02vx8sqpd3rpcypjd99rqkci0fj1bcjznn46p660vpdddpadxya4";
  };

  nativeBuildInputs = [ gtk3 ];

  installPhase = ''
     mkdir -p $out/share/icons
     mv {,e}Papirus* $out/share/icons
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Papirus icon theme";
    homepage = https://github.com/PapirusDevelopmentTeam/papirus-icon-theme;
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
