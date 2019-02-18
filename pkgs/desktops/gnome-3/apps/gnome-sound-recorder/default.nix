{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, gobject-introspection, wrapGAppsHook, gjs, glib, gtk3, gdk_pixbuf, gst_all_1, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-sound-recorder";
  version = "3.28.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1k63xr3d16qbzi88md913ndaf2mzwmhmi6hipj0123sm7nsz1p94";
  };

  patches = [
    # Fix crash when trying to play recordings
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gnome-sound-recorder/commit/2b311ef67909bc20d0e87f334fe37bf5c4e9f29f.patch;
      sha256 = "0hqmk846bxma0p66cqp94zd02zc1if836ywjq3sv5dsfwnz7jv3f";
    })
  ];

  nativeBuildInputs = [ pkgconfig intltool gobject-introspection wrapGAppsHook ];
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
