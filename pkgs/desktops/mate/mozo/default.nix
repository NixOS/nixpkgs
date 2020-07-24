{ stdenv, python3, fetchurl, pkgconfig, gettext, mate, gtk3, glib, wrapGAppsHook, gobject-introspection }:

python3.pkgs.buildPythonApplication rec {
  pname = "mozo";
  version = "1.24.0";

  format = "other";
  doCheck = false;

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "01lyi47a04xk0by5bvnfmqgv5sysk2wdlri6a4ssmy1qhgwh9zr3";
  };

  nativeBuildInputs = [ pkgconfig gettext gobject-introspection wrapGAppsHook ];

  propagatedBuildInputs =  [ mate.mate-menus python3.pkgs.pygobject3 ];

  buildInputs = [ gtk3 glib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "MATE Desktop menu editor";
    homepage = "https://github.com/mate-desktop/mozo";
    license = with licenses; [ lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
