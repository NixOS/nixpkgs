{ v, h, stdenv, fetchXfce, pkgconfig, intltool, gtk
, libxfce4util, xfconf, libglade, libstartup_notification }:

stdenv.mkDerivation rec {
  name = "libxfcegui4-${v}";
  src = fetchXfce.core name h;

  #TODO: gladeui
  # By default, libxfcegui4 tries to install into libglade's prefix.
  # Install into our own prefix instead.
  preConfigure =
    ''
      configureFlags="--with-libglade-module-path=$out/lib/libglade/2.0"
    '';
  #NOTE: missing keyboard library support is OK according to the mailing-list

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util xfconf libglade
      libstartup_notification
    ];
  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = http://www.xfce.org/;
    description = "Basic GUI library for Xfce";
    license = "LGPLv2+";
  };
}
