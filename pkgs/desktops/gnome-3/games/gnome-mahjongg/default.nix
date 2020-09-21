{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, gettext, itstool, libxml2
, meson, ninja, glib, vala, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-mahjongg";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mahjongg/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "N0LcYxD8M/NewYfwJpnfIDzVb27pS0Hz7vJdrinutkc=";
  };

  nativeBuildInputs = [
    meson ninja vala desktop-file-utils
    pkgconfig gnome3.adwaita-icon-theme
    libxml2 itstool gettext wrapGAppsHook
    glib # for glib-compile-schemas
  ];
  buildInputs = [
    glib
    gtk3
    librsvg
  ];

  mesonFlags = [
    "-Dcompile-schemas=enabled"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Mahjongg";
    description = "Disassemble a pile of tiles by removing matching pairs";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
