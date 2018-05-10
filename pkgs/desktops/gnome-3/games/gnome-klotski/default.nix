{ stdenv, fetchurl, pkgconfig, vala, gnome3, gtk3, wrapGAppsHook, appstream-glib, desktop-file-utils
, glib, librsvg, libxml2, intltool, itstool, libgee, libgnome-games-support }:

let
  pname = "gnome-klotski";
  version = "3.22.3";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0prc0s28pdflgzyvk1g0yfx982q2grivmz3858nwpqmbkha81r7f";
  };

  nativeBuildInputs = [ pkgconfig vala wrapGAppsHook intltool itstool libxml2 appstream-glib desktop-file-utils ];
  buildInputs = [ glib gtk3 librsvg libgee libgnome-games-support gnome3.defaultIconTheme ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "${pname}";
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Klotski;
    description = "Slide blocks to solve the puzzle";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
