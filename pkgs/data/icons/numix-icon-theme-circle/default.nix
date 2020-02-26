{ stdenv, fetchFromGitHub, gtk3, numix-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "numix-icon-theme-circle";
  version = "19.12.27";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
    sha256 = "0za44h7f4vk37yl30xlaa6w76maiipb6p63gl9hl1rshdn9nxq0y";
  };

  nativeBuildInputs = [ gtk3 ];

  buildInputs = [ numix-icon-theme ];

  propagatedBuildInputs = [ hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Numix-Circle{,-Light} $out/share/icons/
  '';

  postFixup = ''
    for panel in $out/share/icons/*/*/panel; do
      ln -sf $(realpath ${numix-icon-theme}/share/icons/Numix/16/$(readlink $panel)) $panel
    done

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
    maintainers = with maintainers; [ romildo ];
  };
}
