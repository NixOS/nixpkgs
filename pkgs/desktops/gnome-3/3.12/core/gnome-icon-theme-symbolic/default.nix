{ stdenv, fetchurl, pkgconfig, gnome3, iconnamingutils, gtk }:

stdenv.mkDerivation rec {
  name = "gnome-icon-theme-symbolic-3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-icon-theme-symbolic/3.12/${name}.tar.xz";
    sha256 = "851a4c9d8e8cb0000c9e5e78259ab8b8e67c5334e4250ebcc8dfdaa33520068b";
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
