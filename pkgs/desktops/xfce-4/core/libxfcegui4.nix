{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, xfconf
, libglade, libstartup_notification }:

stdenv.mkDerivation rec {
  name = "libxfcegui4-4.6.4";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/xfce-4.6.2/src/${name}.tar.bz2";
    sha1 = "a12c79f8fa14c5d1fc0fca5615a451b7d23f8695";
  };

  # By default, libxfcegui4 tries to install into libglade's prefix.
  # Install into our own prefix instead.
  preConfigure =
    ''
      configureFlags="--with-libglade-module-path=$out/lib/libglade/2.0"
    '';

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util xfconf libglade
      libstartup_notification
    ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Basic GUI library for Xfce";
    license = "LGPLv2+";
  };
}
