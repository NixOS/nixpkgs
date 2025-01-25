{
  lib,
  mkXfceDerivation,
  glib,
  gtk3,
  thunar,
  libxfce4util,
  gettext,
  taglib,
}:

mkXfceDerivation {
  category = "thunar-plugins";
  pname = "thunar-media-tags-plugin";
  version = "0.5.0";
  odd-unstable = false;

  sha256 = "sha256-71YBA1deR8aV8hoZ4F0TP+Q5sdcVQAB9n3B+pcpJMSQ=";

  nativeBuildInputs = [
    gettext
  ];

  buildInputs = [
    thunar
    glib
    gtk3
    libxfce4util
    taglib
  ];

  meta = with lib; {
    description = "Thunar plugin providing tagging and renaming features for media files";
    maintainers = with maintainers; [ ncfavier ] ++ teams.xfce.members;
  };
}
