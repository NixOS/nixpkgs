{ stdenv, fetchurl, pkgconfig, gnum4, glib, libsigcxx }:

let
  ver_maj = "2.50";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "glibmm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${ver_maj}/${name}.tar.xz";
    sha256 = "df726e3c6ef42b7621474b03b644a2e40ec4eef94a1c5a932c1e740a78f95e94";
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
