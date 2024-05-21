{ lib
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, gnome
, gtk3
, wrapGAppsHook3
, librsvg
, gsound
, gettext
, itstool
, libxml2
, meson
, ninja
, vala
, python3
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-taquin";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-taquin/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0kw131q0ad0rbsp6qifjc8fjlhvjxyihil8a76kj8ya9mn7kvnwn";
  };

  patches = [
    # Fix build with recent Vala.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-taquin/-/commit/99dea5e7863e112f33f16e59898c56a4f1a547b3.patch";
      sha256 = "U7djuMhb1XJaKAPyogQjaunOkbBK24r25YD7BgH05P4=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-taquin/-/commit/66be44dc20d114e449fc33156e3939fd05dfbb16.patch";
      sha256 = "RN41RCLHlJyXTARSH9qjsmpYi1UFeMRssoYxRsbngDQ=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    meson
    ninja
    python3
    gettext
    itstool
    libxml2
    vala
    desktop-file-utils
  ];
  buildInputs = [
    gtk3
    librsvg
    gsound
    gnome.adwaita-icon-theme
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-taquin";
      attrPath = "gnome.gnome-taquin";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-taquin";
    description = "Move tiles so that they reach their places";
    mainProgram = "gnome-taquin";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
