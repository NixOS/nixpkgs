{ stdenv, fetchurl, glib, pkgconfig, libfm-extra }:

let name = "menu-cache-1.0.2";
in
stdenv.mkDerivation {
  inherit name;
  src = fetchurl {
    url = "mirror://sourceforge/lxde/${name}.tar.xz";
    sha256 = "1m8j40npykfcfqs43kc0fmksal2jfmfi8lnb3mq3xy1lvvrfv0vg";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib libfm-extra ];

  meta = with stdenv.lib; {
    homepage = http://blog.lxde.org/?tag=menu-cache;
    license = licenses.gpl2Plus;
    description = "Library to read freedesktop.org menu files";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
