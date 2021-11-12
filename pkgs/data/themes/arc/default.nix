{ lib, stdenv
, fetchFromGitHub
, sassc
, meson
, ninja
, pkg-config
, gtk3
, glib
, gnome
, gtk-engine-murrine
, optipng
, inkscape
, cinnamon
}:

stdenv.mkDerivation rec {
  pname = "arc-theme";
  version = "20211018";

  src = fetchFromGitHub {
    owner = "jnsh";
    repo = pname;
    rev = version;
    sha256 = "1rrxm5b7l8kq1h0lm08ck54xljzm8w573mxx904n3rhdg3ri9d63";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sassc
    optipng
    inkscape
    gtk3
    glib # for glib-compile-resources
  ];

  propagatedUserEnvPkgs = [
    gnome.gnome-themes-extra
    gtk-engine-murrine
  ];

  preBuild = ''
    # Shut up inkscape's warnings about creating profile directory
    export HOME="$NIX_BUILD_ROOT"
  '';

  mesonFlags = [
    "-Dthemes=cinnamon,gnome-shell,gtk2,gtk3,plank,xfwm,metacity"
    "-Dvariants=light,darker,dark,lighter"
    "-Dcinnamon_version=${cinnamon.cinnamon-common.version}"
    "-Dgnome_shell_version=${gnome.gnome-shell.version}"
    "-Dgtk3_version=${gtk3.version}"
    # You will need to patch gdm to make use of this.
    "-Dgnome_shell_gresource=true"
  ];

  meta = with lib; {
    description = "Flat theme with transparent elements for GTK 3, GTK 2 and Gnome Shell";
    homepage = "https://github.com/jnsh/arc-theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ simonvandel romildo ];
  };
}
