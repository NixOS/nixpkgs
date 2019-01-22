{ stdenv, python, fetchurl, pkgconfig, intltool, mate, gtk3, glib, wrapGAppsHook, gobject-introspection }:

python.pkgs.buildPythonApplication rec {
  pname = "mozo";
  version = "1.20.2";

  format = "other";
  doCheck = false;

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${pname}-${version}.tar.xz";
    sha256 = "1q4hqhigimxav2a8xxyd53lq8q80szsphcv37y2jhm6g6wvdmvhd";
  };

  nativeBuildInputs = [ pkgconfig intltool gobject-introspection wrapGAppsHook ];

  propagatedBuildInputs =  [ mate.mate-menus python.pkgs.pygobject3 ];

  buildInputs = [ gtk3 glib ];

  meta = with stdenv.lib; {
    description = "MATE Desktop menu editor";
    homepage = https://github.com/mate-desktop/mozo;
    license = with licenses; [ lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
