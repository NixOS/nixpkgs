{ stdenv, fetchurl, pkgconfig, intltool, glib, gstreamer, gst_plugins_base
, gtk, libxfce4util, libxfce4ui, xfce4panel, xfconf }:

let

  # The usual Gstreamer plugins package has a zillion dependencies
  # that we don't need for a simple mixer, so build a minimal package.
  gst_plugins_minimal = gst_plugins_base.override {
    minimalDeps = true;
  };

in

stdenv.mkDerivation rec {
  name = "xfce4-mixer-4.8.0";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/apps/xfce4-mixer/4.8/${name}.tar.bz2";
    sha1 = "24f3401a68f10d2c620e354a6de98e09fe808665";
  };

  buildInputs =
    [ pkgconfig intltool glib gstreamer gst_plugins_minimal gtk
      libxfce4util libxfce4ui xfce4panel xfconf
    ];

  postInstall =
    ''
      mkdir -p $out/nix-support
      echo ${gst_plugins_minimal} > $out/nix-support/propagated-user-env-packages
    '';

  meta = {
    homepage = http://www.xfce.org/projects/xfce4-mixer;
    description = "A volume control application for the Xfce desktop environment";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
