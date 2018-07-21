{ stdenv, fetchurl, pkgconfig, libxml2, libxslt, gnome3
, gnome-doc-utils, intltool, libX11, which, itstool, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "zenity-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0swavrkc5ps3fwzy6h6l5mmim0wwy10xrq0qqkay5d0zf9a965yv";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "zenity"; attrPath = "gnome3.zenity"; };
  };

  preBuild = ''
    mkdir -p $out/include
  '';

  buildInputs = [ gnome3.gtk libxml2 libxslt libX11 itstool ];

  nativeBuildInputs = [ pkgconfig intltool gnome-doc-utils which wrapGAppsHook ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
