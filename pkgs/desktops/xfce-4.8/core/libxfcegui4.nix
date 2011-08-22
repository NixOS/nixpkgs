{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, xfconf
, libglade, libstartup_notification }:

stdenv.mkDerivation rec {
  name = "libxfcegui4-4.8.1";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/libxfcegui4/4.8/${name}.tar.bz2";
    sha1 = "246fcaa71fc8cf44dae0b4c919411231eedd662f";
  };

  # By default, libxfcegui4 tries to install into libglade's prefix.
  # Install into our own prefix instead.
  preConfigure =
    ''
      configureFlags="--with-libglade-module-path=$out/lib/libglade/2.0"
    '';

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libglade
      libstartup_notification
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/;
    description = "Basic GUI library for Xfce";
    license = "LGPLv2+";
  };
}
