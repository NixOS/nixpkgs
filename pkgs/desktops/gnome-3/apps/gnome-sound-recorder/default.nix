{ stdenv, fetchurl, pkgconfig, intltool, gobjectIntrospection, wrapGAppsHook, gjs, glib, gtk3, gdk_pixbuf, gst_all_1, gnome3 }:

let
  pname = "gnome-sound-recorder";
  version = "3.28.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0y0srj1hvr1waa35p6dj1r1mlgcsscc0i99jni50ijp4zb36fjqy";
  };

  nativeBuildInputs = [ pkgconfig intltool gobjectIntrospection wrapGAppsHook ];
  buildInputs = [ gjs glib gtk3 gdk_pixbuf ] ++ (with gst_all_1; [ gstreamer.dev gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad ]);

  # TODO: fix this in gstreamer
  # TODO: make stdenv.lib.getBin respect outputBin
  PKG_CONFIG_GSTREAMER_1_0_TOOLSDIR = "${gst_all_1.gstreamer.dev}/bin";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "A simple and modern sound recorder";
    homepage = https://wiki.gnome.org/Apps/SoundRecorder;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
