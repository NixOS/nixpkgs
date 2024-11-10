{ lib, stdenv, fetchFromGitHub, fetchpatch
, pkg-config, dbus, gdk-pixbuf, glib, libX11, gtk2, librsvg
, dbus-glib, autoreconfHook, wrapGAppsHook3 }:

stdenv.mkDerivation {
  pname = "volnoti-unstable";
  version = "2013-09-23";

  src = fetchFromGitHub {
    owner = "davidbrazdil";
    repo = "volnoti";
    rev = "4af7c8e54ecc499097121909f02ecb42a8a60d24";
    sha256 = "155lb7w563dkdkdn4752hl0zjhgnq3j4cvs9z98nb25k1xpmpki7";
  };

  patches = [
    # Fix dbus interface headers. See
    # https://github.com/davidbrazdil/volnoti/pull/10
    (fetchpatch {
      url = "https://github.com/davidbrazdil/volnoti/commit/623ad8ea5c3ac8720d00a2ced4b6163aae38c119.patch";
      sha256 = "046zfdjmvhb7jrsgh04vfgi35sgy1zkrhd3bzdby3nvds1wslfam";
    })
  ];

  nativeBuildInputs = [ pkg-config autoreconfHook wrapGAppsHook3 ];

  buildInputs = [
    dbus gdk-pixbuf glib libX11 gtk2 dbus-glib librsvg
  ];

  meta = with lib; {
    description = "Lightweight volume notification for Linux";
    homepage = "https://github.com/davidbrazdil/volnoti";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
