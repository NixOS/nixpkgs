{ lib, stdenv, fetchurl, pkg-config, gnum4, glib, libsigcxx, gnome3, darwin, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "glibmm";
  version = "2.66.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-nh231D0uLU36J3E1TiGmmmvux8RGtxFhnPjHeeE6WB4=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    gnum4
    glib # for glib-compile-schemas
  ];

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Cocoa
  ]);
  propagatedBuildInputs = [ glib libsigcxx ];

  enableParallelBuilding = true;

  doCheck = false; # fails. one test needs the net, another /etc/fstab

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "C++ interface to the GLib library";

    homepage = "https://gtkmm.org/";

    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [raskin];
    platforms = platforms.unix;
  };
}
