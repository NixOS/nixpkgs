{ stdenv, fetchurl, cmake, qtbase, pkgconfig, python, dbus_glib, dbus_daemon
, telepathy_farstream, telepathy_glib, pythonDBus, fetchpatch }:

stdenv.mkDerivation rec {
  name = "telepathy-qt-0.9.6";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/telepathy-qt/${name}.tar.gz";
    sha256 = "0j7hs055cx5g9chn3b2p0arig70m5g9547qgqvk29kxdyxxxsmqc";
  };
  patches = let
    mkUrl = hash: "http://cgit.freedesktop.org/telepathy/telepathy-qt/patch/?id=" + hash;
    in [
      (fetchpatch {
        name = "gst-1.6.patch";
        url = mkUrl "ec4a3d62b68a57254515f01fc5ea3325ffb1dbfb";
        sha256 = "1rh7n3xyrwpvpa3haqi35qn4mfz4396ha43w4zsqpmcyda9y65v2";
      })
      (fetchpatch {
        name = "parallel-make.patch";
        url = mkUrl "7389dc990c67d4269f3a79c924c054e87f2e4ac5";
        sha256 = "0mvdvyy76kpaxacljidf06wd43fr2qripr4mwsakjs3hxb1pkk57";
      })
    ];

  nativeBuildInputs = [ cmake pkgconfig python ];
  propagatedBuildInputs = [ qtbase dbus_glib telepathy_farstream telepathy_glib pythonDBus ];

  buildInputs = stdenv.lib.optional doCheck dbus_daemon;

  cmakeFlags = "-DDESIRED_QT_VERSION=${builtins.substring 0 1 qtbase.version}";

  preBuild = ''
    NIX_CFLAGS_COMPILE+=" `pkg-config --cflags dbus-glib-1`"
  '';

  enableParallelBuilding = true;
  doCheck = false; # giving up for now

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
