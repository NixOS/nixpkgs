{ stdenv, python3, fetchurl, pkgconfig, intltool, mate, gtk3, glib, wrapGAppsHook, gobject-introspection }:

python3.pkgs.buildPythonApplication rec {
  pname = "mozo";
  version = "1.22.1";

  format = "other";
  doCheck = false;

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0yffp7p3b6ynpf7ck21klym7h09l35amnyahm71dxbv2kzj6hlqh";
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
