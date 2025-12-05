{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnum4,
  glib,
  libsigcxx30,
  gnome,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "glibmm";
  version = "2.86.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${lib.versions.majorMinor version}/glibmm-${version}.tar.xz";
    hash = "sha256-OcDp9toEbWeTkHdO/bmtVkQ2I2c23C94JeYUstQIeCY=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    gnum4
    glib # for glib-compile-schemas
  ];

  propagatedBuildInputs = [
    glib
    libsigcxx30
  ];

  doCheck = false; # fails. one test needs the net, another /etc/fstab

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "glibmm";
      attrPath = "glibmm_2_68";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "C++ interface to the GLib library";
    homepage = "https://gtkmm.org/";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ raskin ];
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
}
