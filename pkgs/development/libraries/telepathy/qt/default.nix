{ stdenv, fetchurl, cmake, qtbase, pkgconfig, python, dbus_glib, dbus_daemon
, telepathy_farstream, telepathy_glib, pythonDBus, fetchpatch }:

stdenv.mkDerivation rec {
  name = "telepathy-qt-0.9.6.1";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/telepathy-qt/${name}.tar.gz";
    sha256 = "1y51c6rxk5qvmab98c8rnmrlyk27hnl248casvbq3cd93sav8vj9";
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
        name = "parallel-make-1.patch";
        url = mkUrl "1e1f53e9d91684918c34ec50392f86287e001a1e";
        sha256 = "1f9nk0bi90armb9zay53c7cz70zcwqqwli7sb9wgw76rmwqhl8qw";
      })
      (fetchpatch {
        name = "parallel-make-2.patch";
        url = mkUrl "7389dc990c67d4269f3a79c924c054e87f2e4ac5";
        sha256 = "0mvdvyy76kpaxacljidf06wd43fr2qripr4mwsakjs3hxb1pkk57";
      })
    ];

  nativeBuildInputs = [ cmake pkgconfig python ];
  propagatedBuildInputs = [ qtbase dbus_glib telepathy_farstream telepathy_glib pythonDBus ];

  buildInputs = stdenv.lib.optional doCheck dbus_daemon;

  cmakeFlags = "-DDESIRED_QT_VERSION=${builtins.substring 0 1 qtbase.version}";

  # should be removable after the next update
  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  preBuild = ''
    NIX_CFLAGS_COMPILE+=" `pkg-config --cflags dbus-glib-1`"
  '';

  enableParallelBuilding = true;
  doCheck = false; # giving up for now

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
