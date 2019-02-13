{ stdenv
, fetchurl

, meson
, ninja
, pkgconfig
, gobject-introspection

, dbus
, glib
, libX11
, libXtst # at-spi2-core can be build without X support, but due it is a client-side library, GUI-less usage is a very rare case
, libXi
, fixDarwinDylibNames

, gnome3 # To pass updateScript
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "at-spi2-core";
  version = "2.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0azvgdmmivfz1fki25mz582gmwvfpajcnqhlq7s53nhr7lwzax81";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkgconfig gobject-introspection ]
    # Fixup rpaths because of meson, remove with meson-0.47
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;
  buildInputs = [ dbus glib libX11 libXtst libXi ];

  doCheck = false; # fails with "AT-SPI: Couldn't connect to accessibility bus. Is at-spi-bus-launcher running?"

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Assistive Technology Service Provider Interface protocol definitions and daemon for D-Bus";
    homepage = https://gitlab.gnome.org/GNOME/at-spi2-core;
    license = licenses.lgpl2Plus; # NOTE: 2018-06-06: Please check the license when upstream sorts-out licensing: https://gitlab.gnome.org/GNOME/at-spi2-core/issues/2
    maintainers = with maintainers; [ jtojnar gnome3.maintainers ];
    platforms = platforms.unix;
  };
}
