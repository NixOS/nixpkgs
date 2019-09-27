{ stdenv, fetchFromGitHub, gtk3, numix-icon-theme }:

stdenv.mkDerivation rec {
  pname = "numix-icon-theme-circle";
  version = "19.05.07";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
    sha256 = "04h7kp1895rkfaqrgzrpqjmqamkxv3dkmhslgm2cxsa6qc0wammg";
  };

  nativeBuildInputs = [ gtk3 numix-icon-theme ];

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Numix-Circle{,-Light} $out/share/icons/
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Numix icon theme (circle version)";
    homepage = https://numixproject.github.io;
    license = licenses.gpl3;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
