{ stdenv, fetchurl, cmake, qtbase, pkgconfig, python2Packages, dbus-glib, dbus_daemon
, telepathy-farstream, telepathy-glib, fetchpatch }:

let
  inherit (python2Packages) python dbus-python;
in stdenv.mkDerivation rec {
  name = "telepathy-qt-0.9.7";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/telepathy-qt/${name}.tar.gz";
    sha256 = "0krxd4hhfx6r0ja19wh3848j7gn1rv8jrnakgmkbmi7bww5x7fi1";
  };

  nativeBuildInputs = [ cmake pkgconfig python ];
  propagatedBuildInputs = [ qtbase telepathy-farstream telepathy-glib ];
  buildInputs = [ dbus-glib ];
  checkInputs = [ dbus_daemon dbus-python ];

  patches = [
    # https://github.com/TelepathyIM/telepathy-qt/issues/25
    (fetchpatch {
      url = https://github.com/TelepathyIM/telepathy-qt/commit/d654dc70dbec7097e96e6d96ca74ab1b5b00ef8c.patch;
      sha256 = "1jzd9b9rqh3c8xlq8dr7c0r8aabzf5ywv2gpkk6phh3xwngzrfbh";
    })
  ];

  # No point in building tests if they are not run
  # On 0.9.7, they do not even build with QT4
  cmakeFlags = stdenv.lib.optional (!doCheck) "-DENABLE_TESTS=OFF";

  enableParallelBuilding = true;
  doCheck = false; # giving up for now

  meta = with stdenv.lib; {
    description = "Telepathy Qt bindings";
    homepage = https://telepathy.freedesktop.org/components/telepathy-qt/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
