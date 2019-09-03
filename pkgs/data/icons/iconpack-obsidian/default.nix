{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  pname = "iconpack-obsidian";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "iconpack-obsidian";
    rev = "v${version}";
    sha256 = "0np2s4mbaykwwv516959r5d9gfdmqb5hadsx18x2if4751a9qz49";
  };

  nativeBuildInputs = [ gtk3 ];

  installPhase = ''
     mkdir -p $out/share/icons
     mv Obsidian* $out/share/icons
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Gnome Icon Pack based upon Faenza";
    homepage = https://github.com/madmaxms/iconpack-obsidian;
    license = licenses.lgpl3;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
