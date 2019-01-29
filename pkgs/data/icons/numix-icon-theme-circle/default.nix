{ stdenv, fetchFromGitHub, gtk3, numix-icon-theme }:

stdenv.mkDerivation rec {
  pname = "numix-icon-theme-circle";
  version = "19.01.24";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
    sha256 = "18asihcv41jlysb2ynbvbk6fn0lnj7ckaz1nyx1w25a7nk413dnm";
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
