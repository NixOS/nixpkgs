{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libintl }:

stdenv.mkDerivation rec {
  pname = "lxtask";
  version = "0.1.9";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/${pname}-${version}.tar.xz";
    sha256 = "0cv4hx5dg01hbyi5p10pl78n0a40xajpq4wx9c7886pkmpq8isj1";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ gtk3 libintl ];

  configureFlags = [ "--enable-gtk3" ];

  meta = {
    description = "Lightweight and desktop independent task manager";
    longDescription = ''
      LXTask is a lightweight task manager derived from xfce4 task manager
      with all xfce4 dependencies removed, some bugs fixed, and some
      improvement of UI. Although being part of LXDE, the Lightweight X11
      Desktop Environment, it's totally desktop independent and only
      requires pure GTK.
    '';
    homepage = "https://wiki.lxde.org/en/LXTask";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
