{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  pname = "papirus-icon-theme";
  version = "20190802";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = pname;
    rev = version;
    sha256 = "1i6nh1vy2cjqh4fw1mzq5v4ah613ghf018g8w0npxhj9qi3pyjm5";
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
    # darwin gives hash mismatch in source, probably because of file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
