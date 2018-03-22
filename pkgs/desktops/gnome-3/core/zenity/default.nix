{ stdenv, fetchurl, pkgconfig, cairo, libxml2, libxslt, gnome3, pango
, gnome-doc-utils, intltool, libX11, which, itstool, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "zenity-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1y3dha9faqgy5l8wqh3qp354gzdh36fx70q2kc9k1nw7p498yn2y";
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
