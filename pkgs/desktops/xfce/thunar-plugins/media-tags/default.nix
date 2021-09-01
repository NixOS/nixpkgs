{ lib
, mkXfceDerivation
, gtk3
, thunar
, exo
, libxfce4util
, intltool
, gettext
, taglib
}:

mkXfceDerivation {
  category = "thunar-plugins";
  pname = "thunar-media-tags-plugin";
  version = "0.3.0";

  sha256 = "sha256-jtgcHH5U5GOvzDVUwPEreMtTdk5DT6sXvFPDbzbF684=";

  nativeBuildInputs = [
    intltool
    gettext
  ];

  buildInputs = [
    thunar
    exo
    gtk3
    libxfce4util
    taglib
  ];

  meta = with lib; {
    description = "Thunar plugin providing tagging and renaming features for media files";
    maintainers = with maintainers; [ ncfavier ];
  };
}
