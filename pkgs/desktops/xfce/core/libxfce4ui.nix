{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, xfconf
, libglade, libstartup_notification
, withGtk3 ? false, gtk3
}:

with { inherit (stdenv.lib) optional; };

stdenv.mkDerivation rec {
  p_name  = "libxfce4ui";
  ver_maj = "4.12";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "3d619811bfbe7478bb984c16543d980cadd08586365a7bc25e59e3ca6384ff43";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  #TODO: gladeui
  # Install into our own prefix instead.
  configureFlags = [
    "--with-libglade-module-path=$out/lib/libglade/2.0"
  ] ++ optional withGtk3 "--enable-gtk3";

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util xfconf libglade
      libstartup_notification
    ] ++ optional withGtk3 gtk3;

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/;
    description = "Basic GUI library for Xfce";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
