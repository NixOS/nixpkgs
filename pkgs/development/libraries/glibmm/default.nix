{ lib, stdenv, fetchurl, pkg-config, gnum4, glib, libsigcxx, gnome, darwin, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "glibmm";
  version = "2.66.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-ab1rUydxbKL1EatYCpaf178M0sJM4V4dDlMFktP/IJw=";
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

  doCheck = false; # fails. one test needs the net, another /etc/fstab

  passthru = {
    updateScript = gnome.updateScript {
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
