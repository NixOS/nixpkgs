{ stdenv, fetchFromGitHub, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "numix-icon-theme";
  version = "18.07.17";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
    sha256 = "0clh55kmhc52d33dfm2c6h3lg6ddfh8a088ir9lv1camn9kj55bd";
  };

  nativeBuildInputs = [ gtk3 hicolor-icon-theme ];

  installPhase = ''
    mkdir -p $out/share/icons
    mv Numix{,-Light} $out/share/icons
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Numix icon theme";
    homepage = https://numixproject.github.io;
    license = licenses.gpl3;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo jgeerds ];
  };
}
