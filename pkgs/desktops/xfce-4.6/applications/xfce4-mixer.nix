{ stdenv, fetchurl, pkgconfig, intltool, glib, gstreamer, gst_plugins_base
, gtk, libxfce4util, libxfcegui4, xfce4panel, xfconf, makeWrapper }:

let

  # The usual Gstreamer plugins package has a zillion dependencies
  # that we don't need for a simple mixer, so build a minimal package.
  gst_plugins_minimal = gst_plugins_base.override {
    minimalDeps = true;
  };

in

stdenv.mkDerivation rec {
  name = "xfce4-mixer-4.6.1";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/apps/xfce4-mixer/4.6/${name}.tar.bz2";
    sha1 = "e86163782fc4fc31671c7cb212d23d34106ad3af";
  };

  buildInputs =
    [ pkgconfig intltool glib gstreamer gst_plugins_minimal gtk
      libxfce4util libxfcegui4 xfce4panel xfconf makeWrapper
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
  };
}
