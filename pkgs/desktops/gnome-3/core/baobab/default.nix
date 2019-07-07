{ stdenv, gettext, fetchurl, vala, desktop-file-utils
, meson, ninja, pkgconfig, gtk3, glib, libxml2
, wrapGAppsHook, itstool, gnome3 }:

let
  pname = "baobab";
  version = "3.32.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0b33s9bhpiffv5wl76cq2bbnqhvx3qs2vxyxmil5gcs583llqh9r";
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
    homepage = https://wiki.gnome.org/Apps/DiskUsageAnalyzer;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
