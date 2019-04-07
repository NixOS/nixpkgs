{ stdenv, fetchurl, gnome3, meson, ninja, pkgconfig, gtk3, intltool, glib
, udev, itstool, libxml2, wrapGAppsHook, libnotify, libcanberra-gtk3, gobject-introspection
, gtk-doc, docbook_xsl, docbook_xml_dtd_43, python3 }:

let
  pname = "gnome-bluetooth";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "3.32.1";

  # TODO: split out "lib"
  outputs = [ "out" "dev" "devdoc" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1am1gf0nzwg6x1s8ly13j0xnjzgrfj06j0dp52x4zy9s67ywlhb4";
  };

  nativeBuildInputs = [
    meson ninja intltool itstool pkgconfig libxml2 wrapGAppsHook gobject-introspection
    gtk-doc docbook_xsl docbook_xml_dtd_43 python3
  ];
  buildInputs = [
    glib gtk3 udev libnotify libcanberra-gtk3
    gnome3.adwaita-icon-theme gnome3.gsettings-desktop-schemas
  ];

  mesonFlags = [
    "-Dicon_update=false"
    "-Dgtk_doc=true"
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-bluetooth/stable/index.html.en;
    description = "Application that let you manage Bluetooth in the GNOME destkop";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
