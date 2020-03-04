{ stdenv, fetchurl, pkgconfig, gettext, glib, itstool, libxml2, mate, dconf, gtk3, vte, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-terminal";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0nc23nmbkya2fgf7j65z85dcibwi5akkr8nscqrvk039ckirhk97";
  };

  buildInputs = [
     glib
     itstool
     libxml2

     mate.mate-desktop

     vte
     gtk3
     dconf
  ];

  nativeBuildInputs = [
    pkgconfig
    gettext
    wrapGAppsHook
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The MATE Terminal Emulator";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
