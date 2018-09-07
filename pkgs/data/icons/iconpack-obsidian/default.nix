{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  name = "iconpack-obsidian-${version}";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "iconpack-obsidian";
    rev = "v${version}";
    sha256 = "1mlaldqjc3am2d2m577fhsidlnfqlhmnf1l8hh50iqr94mc14fab";
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
