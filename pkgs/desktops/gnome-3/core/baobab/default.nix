{ lib, stdenv, gettext, fetchurl, vala, desktop-file-utils
, meson, ninja, pkg-config, python3, gtk3, glib, libxml2
, wrapGAppsHook, itstool, gnome3 }:

let
  pname = "baobab";
  version = "3.38.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0ac3fbl15l836yvgw724q4whbkws9v4b6l2xy6bnp0b0g0a6i104";
  };

  nativeBuildInputs = [ meson ninja pkg-config vala gettext itstool libxml2 desktop-file-utils wrapGAppsHook python3 ];
  buildInputs = [ gtk3 glib gnome3.adwaita-icon-theme ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Graphical application to analyse disk usage in any GNOME environment";
    homepage = "https://wiki.gnome.org/Apps/DiskUsageAnalyzer";
    license = licenses.gpl2;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
