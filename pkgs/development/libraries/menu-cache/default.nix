{ stdenv, fetchurl, glib, pkgconfig, libfm-extra }:

let name = "menu-cache-1.0.1";
in
stdenv.mkDerivation {
  inherit name;
  src = fetchurl {
    url = "mirror://sourceforge/lxde/${name}.tar.xz";
    sha256 = "0ngxvwfj9drabqi3lyzgpi0d0za6431sy2ijb010filrj54jdiqa";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib libfm-extra ];

  meta = with stdenv.lib; {
    homepage = "http://blog.lxde.org/?tag=menu-cache";
    license = licenses.gpl2Plus;
    description = "Library to read freedesktop.org menu files";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux;
  };
}
