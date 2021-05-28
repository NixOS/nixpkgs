{ stdenv, gettext, fetchurl, vala, desktop-file-utils
, meson, ninja, pkgconfig, gtk3, glib, libxml2
, wrapGAppsHook, itstool, gnome3 }:

let
  pname = "baobab";
  version = "3.34.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1i90gc1cpw5507zn54k46hj4mjgdxsq8cvpnlgxq0ksy2d7iv63z";
  };

  nativeBuildInputs = [ meson ninja pkgconfig vala gettext itstool libxml2 desktop-file-utils wrapGAppsHook ];
  buildInputs = [ gtk3 glib gnome3.adwaita-icon-theme ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Graphical application to analyse disk usage in any GNOME environment";
    homepage = "https://wiki.gnome.org/Apps/DiskUsageAnalyzer";
    license = licenses.gpl2;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
