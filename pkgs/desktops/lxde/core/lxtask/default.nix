{ stdenv, fetchurl, pkgconfig, intltool, gtk3 }:

stdenv.mkDerivation rec {
  name = "lxtask-${version}";
  version = "0.1.8";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/${name}.tar.xz";
    sha256 = "0h7g1fdngv939z1d05nzs86dplww5a3bpm0isxd7p1bjby047d6z";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ gtk3 ];

  configureFlags = [ "--enable-gtk3" ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  meta = {
    description = "Lightweight and desktop independent task manager";
    longDescription = ''
      LXTask is a lightweight task manager derived from xfce4 task manager
      with all xfce4 dependencies removed, some bugs fixed, and some
      improvement of UI. Although being part of LXDE, the Lightweight X11
      Desktop Environment, it's totally desktop independent and only
      requires pure gtk+.
    '';
    homepage = https://wiki.lxde.org/en/LXTask;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
