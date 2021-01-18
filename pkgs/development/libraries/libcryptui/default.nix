{ stdenv, fetchurl, autoreconfHook, pkgconfig, intltool, glib, gnome3, gtk3, gnupg22, gpgme, dbus-glib, libgnome-keyring }:

stdenv.mkDerivation rec {
  pname = "libcryptui";
  version = "3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0rh8wa5k2iwbwppyvij2jdxmnlfjbna7kbh2a5n7zw4nnjkx3ski";
  };

  patches = [
    ./fix-gnupg-2.2.patch # based on https://gitlab.gnome.org/GNOME/libcryptui/-/commit/b05e301d1b264a5d8f07cb96e5edc243d99bff79.patch
  ];

  nativeBuildInputs = [ pkgconfig intltool autoreconfHook ];
  buildInputs = [ glib gtk3 gnupg22 gpgme dbus-glib libgnome-keyring ];
  propagatedBuildInputs = [ dbus-glib ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Interface components for OpenPGP";
    homepage = "https://gitlab.gnome.org/GNOME/libcryptui";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
