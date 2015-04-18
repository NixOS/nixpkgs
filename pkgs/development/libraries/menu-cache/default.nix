{ stdenv, fetchurl, glib, pkgconfig, libfm-extra }:

let name = "menu-cache-0.7.0";
in
stdenv.mkDerivation {
  inherit name;
  src = fetchurl {
    url = "mirror://sourceforge/lxde/${name}.tar.xz";
    sha256 = "0wwkk4jrcl2sp11bspabplchh4ipi1zyn39j3skyzgbm8k40gkhk";
  };

  buildInputs = [ glib pkgconfig libfm-extra ];

  meta = with stdenv.lib; {
    homepage = "http://blog.lxde.org/?tag=menu-cache";
    license = licenses.gpl2Plus;
    description = "Library to read freedesktop.org menu files";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux;
  };
}
