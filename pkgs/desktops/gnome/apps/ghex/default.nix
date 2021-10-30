{ stdenv
, lib
, fetchurl
, pkg-config
, meson
, ninja
, python3
, gnome
, desktop-file-utils
, appstream-glib
, gettext
, itstool
, libxml2
, gtk3
, glib
, atk
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "ghex";
  version = "3.41.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/ghex/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "KcdG8ihzteQVvDly29PdYNalH3CA5qPpVsNNZHrjRKI=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    atk
    glib
  ];

  checkInputs = [
    appstream-glib
    desktop-file-utils
  ];

  postPatch = ''
     chmod +x meson_post_install.py
     patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "ghex";
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Ghex";
    description = "Hex editor for GNOME desktop environment";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
  };
}
