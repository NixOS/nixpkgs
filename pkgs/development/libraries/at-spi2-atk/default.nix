{ stdenv
, fetchurl

, meson
, ninja
, pkgconfig

, at-spi2-core
, atk
, dbus
, glib
, libxml2
, fixDarwinDylibNames

, gnome3 # To pass updateScript
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "at-spi2-atk";
  version = "2.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "16lav8k3mcxf2hblfh95zcw41glmb92wwwwljrf10yza0h85gqg2";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ]
    # Fixup rpaths because of meson, remove with meson-0.47
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;
  buildInputs = [ at-spi2-core atk dbus glib libxml2 ];

  doCheck = false; # fails with "No test data file provided"

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "D-Bus bridge for Assistive Technology Service Provider Interface (AT-SPI) and Accessibility Toolkit (ATK)";
    homepage = https://gitlab.gnome.org/GNOME/at-spi2-atk;
    license = licenses.lgpl2Plus; # NOTE: 2018-06-06: Please check the license when upstream sorts-out licensing: https://gitlab.gnome.org/GNOME/at-spi2-atk/issues/2
    maintainers = with maintainers; [ jtojnar gnome3.maintainers ];
    platforms = platforms.unix;
  };
}
