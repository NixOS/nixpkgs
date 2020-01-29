{ stdenv, python3, fetchurl, pkgconfig, intltool, mate, gtk3, glib, wrapGAppsHook, gobject-introspection }:

python3.pkgs.buildPythonApplication rec {
  pname = "mozo";
  version = "1.22.2";

  format = "other";
  doCheck = false;

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1lzcwsz940v218frwzhpywp1an9x3cgfvqr7r8dplpdapvd0khrs";
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
