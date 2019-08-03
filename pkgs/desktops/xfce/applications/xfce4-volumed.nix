{ stdenv, fetchurl, pkgconfig, makeWrapper
, gstreamer, gtk2, gst-plugins-base, libnotify
, keybinder, xfconf
}:

let
  # The usual Gstreamer plugins package has a zillion dependencies
  # that we don't need for a simple mixer, so build a minimal package.
  gst_plugins_minimal = gst-plugins-base.override {
    minimalDeps = true;
  };

in

stdenv.mkDerivation rec {
  p_name  = "xfce4-volumed";
  ver_maj = "0.1";
  ver_min = "13";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1aa0a1sbf9yzi7bc78kw044m0xzg1li3y4w9kf20wqv5kfjs7v2c";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs =
    [ gstreamer gst_plugins_minimal gtk2
      keybinder xfconf libnotify
    ];

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  postInstall =
    ''
      wrapProgram "$out/bin/xfce4-volumed" \
        --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH"
    '';

  meta = with stdenv.lib; {
    homepage = https://www.xfce.org/projects/xfce4-volumed; # referenced but inactive
    description = "A volume keys control daemon for the Xfce desktop environment";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.abbradar ];
  };
}
