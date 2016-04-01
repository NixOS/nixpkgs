{ stdenv, fetchurl, pkgconfig, gnum4, glib, libsigcxx }:

let
  ver_maj = "2.46";
  ver_min = "3";
in
stdenv.mkDerivation rec {
  name = "glibmm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${ver_maj}/${name}.tar.xz";
    sha256 = "c78654addeb27a1213bedd7cd21904a45bbb98a5ba2f2f0de2b2f1a5682d86cf";
  };

  nativeBuildInputs = [ pkgconfig gnum4 ];
  propagatedBuildInputs = [ glib libsigcxx ];

  enableParallelBuilding = true;
  #doCheck = true; # some tests need network

  meta = with stdenv.lib; {
    description = "C++ interface to the GLib library";

    homepage = http://gtkmm.org/;

    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [raskin];
    platforms = platforms.unix;
  };
}
