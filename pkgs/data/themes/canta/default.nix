{ stdenv
, fetchFromGitHub
, gdk-pixbuf
, librsvg
, gtk-engine-murrine
, gtk3
, gnome3
, gnome-icon-theme
, numix-icon-theme-circle
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "canta-theme";
  version = "2020-05-17";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "0b9ffkw611xxb2wh43sjqla195jp0ygxph5a8dvifkxdw6nxc2y0";
  };

  nativeBuildInputs = [
    gtk3
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedBuildInputs = [
    gnome3.adwaita-icon-theme
    gnome-icon-theme
    numix-icon-theme-circle
    hicolor-icon-theme
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./install.sh --dest $out/share/themes
    rm $out/share/themes/*/{AUTHORS,COPYING}
    install -D -t $out/share/backgrounds wallpaper/canta-wallpaper.svg
    mkdir -p $out/share/icons
    cp -a icons/Canta $out/share/icons
    gtk-update-icon-cache $out/share/icons/Canta
  '';

  meta = with stdenv.lib; {
    description = "Flat Design theme for GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/Canta-theme";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
