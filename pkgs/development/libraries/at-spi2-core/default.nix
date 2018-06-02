{ stdenv
, fetchurl

, meson
, ninja
, pkgconfig
, gobjectIntrospection

, dbus
, glib
, libX11
, libXtst # at-spi2-core can be build with custom option not to support X, but due to it is a aplication client-side library, GUI-less usage is a very rare case
, libXi
}:

stdenv.mkDerivation rec {
  name = "${moduleName}-${version}";
  moduleName   = "at-spi2-core";
  version = "2.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "11qwdxxx4jm0zj04xydlwah41axiz276dckkiql3rr0wn5x4i8j2";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkgconfig gobjectIntrospection ];
  buildInputs = [ dbus glib libX11 libXtst libXi ];

  meta = with stdenv.lib; {
    description = "Assistive Technology Service Provider Interface protocol definitions and daemon for D-Bus";
    homepage = https://gitlab.gnome.org/GNOME/at-spi2-core;
    license = licenses.lgpl2Plus; # NOTE: 2018-06-06: Please check the license when upstream sorts-out licensing: https://gitlab.gnome.org/GNOME/at-spi2-core/issues/2
    maintainers = with maintainers; [ jtojnar gnome3.maintainers ];
    platforms = platforms.unix;
  };
}
