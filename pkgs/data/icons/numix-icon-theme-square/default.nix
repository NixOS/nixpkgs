{ stdenv, fetchFromGitHub, gtk3, numix-icon-theme }:

stdenv.mkDerivation rec {
  pname = "numix-icon-theme-square";
  version = "19.05.07";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
    sha256 = "13wxy36qys439pv0xaynqvmjshnfrk9wa89iw878ibvfj506ji2s";
  };

  nativeBuildInputs = [ gtk3 numix-icon-theme ];

  installPhase = ''
    mkdir -p $out/share/icons
    cp -a Numix-Square{,-Light} $out/share/icons/
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Numix icon theme (square version)";
    homepage = https://numixproject.github.io;
    license = licenses.gpl3;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
