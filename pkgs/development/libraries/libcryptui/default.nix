{ stdenv, fetchurl, pkgconfig, intltool, glib, gnome3, gtk3, gnupg20, gpgme, dbus-glib, libgnome-keyring }:

stdenv.mkDerivation rec {
  pname = "libcryptui";
  version = "3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0rh8wa5k2iwbwppyvij2jdxmnlfjbna7kbh2a5n7zw4nnjkx3ski";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ glib gtk3 gnupg20 gpgme dbus-glib libgnome-keyring ];
  propagatedBuildInputs = [ dbus-glib ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Interface components for OpenPGP";
    homepage = https://gitlab.gnome.org/GNOME/libcryptui;
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
