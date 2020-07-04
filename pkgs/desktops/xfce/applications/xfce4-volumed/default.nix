{ stdenv, fetchurl, pkgconfig, makeWrapper
, gstreamer, gtk2, gst-plugins-base, libnotify
, keybinder, xfconf, xfce
}:

let
  category = "apps";

  # The usual Gstreamer plugins package has a zillion dependencies
  # that we don't need for a simple mixer, so build a minimal package.
  gst_plugins_minimal = gst-plugins-base.override {
    minimalDeps = true;
  };

in

stdenv.mkDerivation rec {
  pname  = "xfce4-volumed";
  version = "0.1.13";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "1aa0a1sbf9yzi7bc78kw044m0xzg1li3y4w9kf20wqv5kfjs7v2c";
  };

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

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://www.xfce.org/projects/xfce4-volumed"; # referenced but inactive
    description = "A volume keys control daemon for the Xfce desktop environment";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.abbradar ];
  };
}
