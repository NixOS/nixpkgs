{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, vala
, glib
, gtk4
, libgee
, libgnome-games-support_2_0
, pango
, gnome
, desktop-file-utils
, gettext
, itstool
, libxml2
, wrapGAppsHook4
, python3
}:

stdenv.mkDerivation rec {
  pname = "swell-foop";
  version = "46.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "bLlVidWY5LN2bqVcImYfiK85B4phh9eoqo/c8931EuM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
    python3
    itstool
    gettext
    libxml2
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libgee
    libgnome-games-support_2_0
    pango
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py

    substituteInPlace meson_post_install.py \
      --replace-fail "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Swell%20Foop";
    description = "Puzzle game, previously known as Same GNOME";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
