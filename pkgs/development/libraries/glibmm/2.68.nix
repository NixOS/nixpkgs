{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnum4,
  glib,
  libsigcxx30,
  gnome,
  Cocoa,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "glibmm";
  version = "2.80.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-U5sKKeFalmdsTwWUVBJQVmxcpE2l1Nh6NzL6LQeQnko=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    gnum4
    glib # for glib-compile-schemas
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    Cocoa
  ];

  propagatedBuildInputs = [
    glib
    libsigcxx30
  ];

  doCheck = false; # fails. one test needs the net, another /etc/fstab

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "glibmm_2_68";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "C++ interface to the GLib library";
    homepage = "https://gtkmm.org/";
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ raskin ]);
    platforms = platforms.unix;
  };
}
