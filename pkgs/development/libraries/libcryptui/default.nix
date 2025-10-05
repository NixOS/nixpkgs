{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  gettext,
  pkg-config,
  intltool,
  glib,
  gnome,
  gtk3,
  gtk-doc,
  gnupg,
  gpgme,
  dbus-glib,
  libgnome-keyring,
}:

stdenv.mkDerivation rec {
  pname = "libcryptui";
  version = "3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/libcryptui/${lib.versions.majorMinor version}/libcryptui-${version}.tar.xz";
    sha256 = "0rh8wa5k2iwbwppyvij2jdxmnlfjbna7kbh2a5n7zw4nnjkx3ski";
  };

  patches = [
    # based on https://gitlab.gnome.org/GNOME/libcryptui/-/commit/b05e301d1b264a5d8f07cb96e5edc243d99bff79.patch
    # https://gitlab.gnome.org/GNOME/libcryptui/-/merge_requests/1
    ./fix-latest-gnupg.patch
  ];

  nativeBuildInputs = [
    pkg-config
    dbus-glib # dbus-binding-tool
    gtk3 # AM_GLIB_GNU_GETTEXT
    gtk-doc
    intltool
    autoreconfHook
  ];
  buildInputs = [
    glib
    gtk3
    gnupg
    gpgme
    dbus-glib
    libgnome-keyring
  ];
  propagatedBuildInputs = [ dbus-glib ];

  env.GNUPG = lib.getExe gnupg;
  env.GPGME_CONFIG = lib.getExe' (lib.getDev gpgme) "gpgme-config";

  enableParallelBuilding = true;

  preAutoreconf = ''
    # error: possibly undefined macro: AM_NLS
    cp ${gettext}/share/gettext/m4/nls.m4 m4
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libcryptui";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Interface components for OpenPGP";
    mainProgram = "seahorse-daemon";
    homepage = "https://gitlab.gnome.org/GNOME/libcryptui";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    # ImportError: lib/gobject-introspection/giscanner/_giscanner.cpython-312-x86_64-linux-gnu.so
    # cannot open shared object file: No such file or directory
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}
