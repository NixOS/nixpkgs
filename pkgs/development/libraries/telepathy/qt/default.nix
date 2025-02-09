{
  lib,
  stdenv,
  fetchurl,
  cmake,
  qtbase,
  pkg-config,
  python3Packages,
  dbus-glib,
  dbus,
  telepathy-farstream,
  telepathy-glib,
}:

let
  inherit (python3Packages) python dbus-python;
in
stdenv.mkDerivation rec {
  pname = "telepathy-qt";
  version = "0.9.8";

  src = fetchurl {
    url = "https://telepathy.freedesktop.org/releases/telepathy-qt/telepathy-qt-${version}.tar.gz";
    sha256 = "bf8e2a09060addb80475a4938105b9b41d9e6837999b7a00e5351783857e18ad";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python
  ];
  propagatedBuildInputs = [
    qtbase
    telepathy-farstream
    telepathy-glib
  ];
  buildInputs = [ dbus-glib ];
  nativeCheckInputs = [
    dbus
    dbus-python
  ];

  # No point in building tests if they are not run
  # On 0.9.7, they do not even build with QT4
  cmakeFlags = lib.optional (!doCheck) "-DENABLE_TESTS=OFF";

  dontWrapQtApps = true;

  doCheck = false; # giving up for now

  meta = with lib; {
    description = "Telepathy Qt bindings";
    homepage = "https://telepathy.freedesktop.org/components/telepathy-qt/";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
