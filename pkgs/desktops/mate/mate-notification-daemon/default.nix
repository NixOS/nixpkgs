{ stdenv, fetchurl, pkgconfig, gettext, glib, libcanberra-gtk3,
  libnotify, libwnck3, gtk3, libxml2, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-notification-daemon";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1ybzr8mni5pgrspf8hqnisd0r0hwdlgk7n5mzsh7xisbkgivpw2b";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    libxml2 # for xmllint
    wrapGAppsHook
  ];

  buildInputs = [
    libcanberra-gtk3
    libnotify
    libwnck3
    gtk3
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Notification daemon for MATE Desktop";
    homepage = "https://github.com/mate-desktop/mate-notification-daemon";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
