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
    hash = "sha256-v44qCQYK3bgEdaSTgQW5tB2eaDeZm3oA5TUXg4V+GK0=";
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

  meta = {
    description = "Telepathy Qt bindings";
    homepage = "https://telepathy.freedesktop.org/components/telepathy-qt/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
  };
}
