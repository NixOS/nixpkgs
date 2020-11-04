{ stdenv, fetchurl, pkgconfig, gnum4, glib, libsigcxx, gnome3, darwin }:

stdenv.mkDerivation rec {
  pname = "glibmm";
  version = "2.64.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1v6lp23fr2qh4zshcnm28sn29j3nzgsvcqj2nhmrnvamipjq4lm7";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig
    gnum4
    glib # for glib-compile-schemas
  ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Cocoa
  ]);
  propagatedBuildInputs = [ glib libsigcxx ];

  enableParallelBuilding = true;

  doCheck = false; # fails. one test needs the net, another /etc/fstab

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "C++ interface to the GLib library";

    homepage = "https://gtkmm.org/";

    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [raskin];
    platforms = platforms.unix;
  };
}
