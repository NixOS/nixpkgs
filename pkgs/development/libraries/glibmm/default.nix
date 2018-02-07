{ stdenv, fetchurl, pkgconfig, gnum4, glib, libsigcxx }:

let
  ver_maj = "2.54";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "glibmm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${ver_maj}/${name}.tar.xz";
    sha256 = "0jkapw18icz59cmlmsl00nwwz0wh291kb4hc9z9hxmq45drqrhkw";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig gnum4 ];
  propagatedBuildInputs = [ glib libsigcxx ];

  enableParallelBuilding = true;
  #doCheck = true; # some tests need network

  meta = with stdenv.lib; {
    description = "C++ interface to the GLib library";

    homepage = https://gtkmm.org/;

    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [raskin];
    platforms = platforms.unix;
  };
}
