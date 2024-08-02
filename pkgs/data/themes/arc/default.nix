{ lib, stdenv
, fetchFromGitHub
, sassc
, meson
, ninja
, glib
, gnome
, gnome-themes-extra
, gtk-engine-murrine
, inkscape
, cinnamon-common
, makeFontsConf
, python3
}:

stdenv.mkDerivation rec {
  pname = "arc-theme";
  version = "20221218";

  src = fetchFromGitHub {
    owner = "jnsh";
    repo = pname;
    rev = version;
    sha256 = "sha256-7VmqsUCeG5GwmrVdt9BJj0eZ/1v+no/05KwGFb7E9ns=";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
    inkscape
    glib # for glib-compile-resources
    python3
  ];

  propagatedUserEnvPkgs = [
    gnome-themes-extra
    gtk-engine-murrine
  ];

  postPatch = ''
    patchShebangs meson/install-file.py
  '';

  preBuild = ''
    # Shut up inkscape's warnings about creating profile directory
    export HOME="$TMPDIR"
  '';

  # Fontconfig error: Cannot load default config file: No such file: (null)
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  mesonFlags = [
    # "-Dthemes=cinnamon,gnome-shell,gtk2,gtk3,plank,xfwm,metacity"
    # "-Dvariants=light,darker,dark,lighter"
    "-Dcinnamon_version=${cinnamon-common.version}"
    "-Dgnome_shell_version=${gnome.gnome-shell.version}"
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
