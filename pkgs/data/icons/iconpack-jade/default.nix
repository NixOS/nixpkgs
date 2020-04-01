{ stdenv, fetchFromGitHub, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "iconpack-jade";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = pname;
    rev = "v${version}";
    sha256 = "1piypv8wdxnfiy6kgh7i3wi52m4fh4x874kh01qjmymssyirn17x";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
     mkdir -p $out/share/icons
     cp -a Jade* $out/share/icons
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Icon pack based upon Faenza and Mint-X";
    homepage = "https://github.com/madmaxms/iconpack-jade";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
