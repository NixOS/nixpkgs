{ stdenv, fetchurl, pkgconfig, intltool, xorg, gtk, libxfce4util, xfconf
, libglade, libstartup_notification, hicolor-icon-theme
, withGtk3 ? false, gtk3
}:
let
  p_name  = "libxfce4ui";
  ver_maj = "4.12";
  ver_min = "1";
  inherit (stdenv.lib) optional;
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "3d619811bfbe7478bb984c16543d980cadd08586365a7bc25e59e3ca6384ff43";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs =
    [ gtk libxfce4util xfconf libglade
      libstartup_notification hicolor-icon-theme
    ] ++ optional withGtk3 gtk3;

  propagatedBuildInputs = [ xorg.libICE xorg.libSM ];

  #TODO: glade?
  configureFlags = optional withGtk3 "--enable-gtk3";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.xfce.org/;
    description = "Basic GUI library for Xfce";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}

