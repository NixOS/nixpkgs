{ stdenv, python3, fetchurl, pkgconfig, intltool, mate, gtk3, glib, wrapGAppsHook, gobject-introspection }:

python3.pkgs.buildPythonApplication rec {
  pname = "mozo";
  version = "1.22.0";

  format = "other";
  doCheck = false;

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${pname}-${version}.tar.xz";
    sha256 = "0pmkprby10ys1xas9w1xqdm48l3bl82cysyj39n7br9ddijwb7kz";
  };

  nativeBuildInputs = [ pkgconfig intltool gobject-introspection wrapGAppsHook ];

  propagatedBuildInputs =  [ mate.mate-menus python3.pkgs.pygobject3 ];

  buildInputs = [ gtk3 glib ];

  meta = with stdenv.lib; {
    description = "MATE Desktop menu editor";
    homepage = https://github.com/mate-desktop/mozo;
    license = with licenses; [ lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
