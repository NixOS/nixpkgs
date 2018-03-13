{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libxml2, intltool, itstool, libgee, libgames-support }:

stdenv.mkDerivation rec {
  name = "gnome-klotski-${version}";
  version = "3.22.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-klotski/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0prc0s28pdflgzyvk1g0yfx982q2grivmz3858nwpqmbkha81r7f";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-klotski"; attrPath = "gnome3.gnome-klotski"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook intltool itstool librsvg libxml2 libgee libgames-support
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Klotski;
    description = "Slide blocks to solve the puzzle";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
