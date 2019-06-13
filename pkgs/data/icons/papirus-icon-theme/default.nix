{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  pname = "papirus-icon-theme";
  version = "20190521";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = pname;
    rev = version;
    sha256 = "192s14bf2ni46jkiifbsl82qy1miy8fnxs2fpqwf6s6jlv9x4zxs";
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
