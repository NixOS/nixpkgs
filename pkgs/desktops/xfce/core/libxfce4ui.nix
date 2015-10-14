{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, xfconf
, libglade, libstartup_notification, hicolor_icon_theme }:
let
  p_name  = "libxfce4ui";
  ver_maj = "4.12";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "3d619811bfbe7478bb984c16543d980cadd08586365a7bc25e59e3ca6384ff43";
  };

  outputs = [ "dev" "out" "doc" ]; # dev-doc only

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util xfconf libglade
      libstartup_notification hicolor_icon_theme
    ];

  #TODO: gladeui
  # Install into our own prefix instead.
  configureFlags = [
    "--with-libglade-module-path=$(out)/lib/libglade/2.0"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.xfce.org/;
    description = "Basic GUI library for Xfce";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}

