{ stdenv, fetchurl, pkgconfig, intltool, glib, gst_all, gtk
, libxfce4util, libxfcegui4, xfce4panel, xfconf, makeWrapper }:

let

  # The usual Gstreamer plugins package has a zillion dependencies
  # that we don't need for a simple mixer, so build a minimal package.
  gstPluginsBase = gst_all.gstPluginsBase.override {
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
    [ pkgconfig intltool glib gst_all.gstreamer gstPluginsBase gtk
      libxfce4util libxfcegui4 xfce4panel xfconf makeWrapper
    ];

  postInstall =
    ''
      mkdir -p $out/nix-support
      echo ${gstPluginsBase} > $out/nix-support/propagated-user-env-packages
    '';

  meta = {
    homepage = http://www.xfce.org/projects/xfce4-mixer;
    description = "A volume control application for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
