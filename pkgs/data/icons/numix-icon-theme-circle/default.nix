{ stdenv, fetchFromGitHub, gtk3, numix-icon-theme }:

stdenv.mkDerivation rec {
  version = "18.09.19";

  package-name = "numix-icon-theme-circle";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "1a1ack4kpngnb3c281pssmp3snn2idcn2c5cv3l38a0dl5g5w8nq";
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
    maintainers = with maintainers; [ jgeerds ];
  };
}
