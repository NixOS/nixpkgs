{ stdenv, fetchurl, pkgconfig, gnome3, iconnamingutils, gtk }:

stdenv.mkDerivation rec {
  name = "gnome-icon-theme-symbolic-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-icon-theme-symbolic/3.10/${name}.tar.xz";
    sha256 = "344e88e5f9dac3184bf012d9bac972110df2133b93d76f2ad128d4c9cbf41412";
  };

  configureFlags = "--enable-icon-mapping";

  # Avoid postinstall make hooks
  installPhase = ''
    make install-exec-am install-data-local install-pkgconfigDATA
    make -C src install
  '';

  buildInputs = [ pkgconfig iconnamingutils gtk gnome3.gnome_icon_theme ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
