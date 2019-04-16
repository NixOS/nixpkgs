{ stdenv, fetchurl, pkgconfig, gnum4, glib, libsigcxx, gnome3, darwin }:

stdenv.mkDerivation rec {
  pname = "glibmm";
  version = "2.60.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1g7jxqd270dv2d83r7pf5893mwpz7d5xib0q01na2yalh34v38d3";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig gnum4 ];
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

    homepage = https://gtkmm.org/;

    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [raskin];
    platforms = platforms.unix;
  };
}
