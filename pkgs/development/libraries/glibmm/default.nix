{ stdenv, fetchurl, pkgconfig, gnum4, glib, libsigcxx, gnome3 }:

stdenv.mkDerivation rec {
  pname = "glibmm";
  version = "2.58.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0idnaii4h3mdym2a55gkavipyxigwvbgfmzmwql85s4rgciqjhfk";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig gnum4 ];
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
