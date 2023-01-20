{ lib, stdenv
, fetchurl

, meson
, ninja
, pkg-config

, at-spi2-core
, atk
, dbus
, glib
, libxml2

, gnome # To pass updateScript
}:

stdenv.mkDerivation rec {
  pname = "at-spi2-atk";
  version = "2.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "z6AIpa+CKzauYofxgYLEDJHdaZxV+qOGBYge0XXKRk8=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ at-spi2-core atk dbus glib libxml2 ];

  doCheck = false; # fails with "No test data file provided"

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "D-Bus bridge for Assistive Technology Service Provider Interface (AT-SPI) and Accessibility Toolkit (ATK)";
    homepage = "https://gitlab.gnome.org/GNOME/at-spi2-atk";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
