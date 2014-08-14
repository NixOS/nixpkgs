{ stdenv, fetchurl, pkgconfig, glib, libsigcxx }:

let
  ver_maj = "2.38";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "glibmm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${ver_maj}/${name}.tar.xz";
    sha256 = "18n4czi6lh4ncj54apxms18xn9k8pmrp2ba9sxn0sk9w3pp2bja9";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libsigcxx ];

  #doCheck = true; # some tests need network

  meta = {
    description = "C++ interface to the GLib library";

    homepage = http://gtkmm.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [urkud raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
