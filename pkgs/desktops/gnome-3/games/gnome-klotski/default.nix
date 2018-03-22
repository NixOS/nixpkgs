{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libxml2, intltool, itstool, libgee, libgames-support }:

stdenv.mkDerivation rec {
  name = "gnome-klotski-${version}";
  version = "3.22.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-klotski/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "16hd6yk01rhb4pj8m01fyn72wykf41d72gsms81q0n4zm5bm1a4h";
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
