{ lib, stdenv, fetchzip, atk, cairo, dcompiler, gdk-pixbuf, gnome, gst_all_1, librsvg
, glib, gtk3, gtksourceview4, libgda, libpeas, pango, pkg-config, which, vte }:

let
  inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-bad;
in stdenv.mkDerivation rec {
  pname = "gtkd";
  version = "3.10.0";

  src = fetchzip {
    url = "https://gtkd.org/Downloads/sources/GtkD-${version}.zip";
    sha256 = "DEKVDexGyg/T3SdnnvRjaHq1LbDo8ekNslxKROpMCCE=";
    stripRoot = false;
  };

  nativeBuildInputs = [ dcompiler pkg-config which ];
  propagatedBuildInputs = [
    atk cairo gdk-pixbuf glib gstreamer gst-plugins-base gtk3 gtksourceview4
    libgda libpeas librsvg pango vte
  ];

  postPatch = ''
    substituteAll ${./paths.d} generated/gtkd/gtkd/paths.d

    substituteInPlace generated/gstreamer/gst/app/c/functions.d \
      --replace libgstapp-1.0.so.0 ${gst-plugins-base}/lib/libgstapp-1.0.so.0 \
      --replace libgstapp-1.0.0.dylib ${gst-plugins-base}/lib/libgstapp-1.0.0.dylib

    substituteInPlace generated/gstreamer/gst/base/c/functions.d \
      --replace libgstbase-1.0.so.0 ${gstreamer.out}/lib/libgstbase-1.0.so.0 \
      --replace libgstbase-1.0.0.dylib ${gstreamer.out}/lib/libgstbase-1.0.0.dylib

    substituteInPlace generated/gstreamer/gst/mpegts/c/functions.d \
      --replace libgstmpegts-1.0.so.0 ${gst-plugins-bad.out}/lib/libgstmpegts-1.0.so.0 \
      --replace libgstmpegts-1.0.0.dylib ${gst-plugins-bad.out}/lib/libgstmpegts-1.0.0.dylib

    substituteInPlace generated/gstreamer/gstinterfaces/c/functions.d \
      --replace libgstvideo-1.0.so.0 ${gst-plugins-base}/lib/libgstvideo-1.0.so.0 \
      --replace libgstvideo-1.0.0.dylib ${gst-plugins-base}/lib/libgstvideo-1.0.0.dylib

    substituteInPlace generated/gstreamer/gstreamer/c/functions.d \
      --replace libgstreamer-1.0.so.0 ${gstreamer}/lib/libgstreamer-1.0.so.0 \
      --replace libgstreamer-1.0.0.dylib ${gstreamer}/lib/libgstreamer-1.0.0.dylib

    substituteInPlace generated/gtkd/atk/c/functions.d \
      --replace libatk-1.0.so.0 ${atk}/lib/libatk-1.0.so.0 \
      --replace libatk-1.0.0.dylib ${atk}/lib/libatk-1.0.0.dylib

    substituteInPlace generated/gtkd/cairo/c/functions.d \
      --replace libcairo.so.2 ${cairo}/lib/libcairo.so.2 \
      --replace libcairo.dylib ${cairo}/lib/libcairo.dylib

    substituteInPlace generated/gtkd/gdk/c/functions.d \
      --replace libgdk-3.so.0 ${gtk3}/lib/libgdk-3.so.0 \
      --replace libgdk-3.0.dylib ${gtk3}/lib/libgdk-3.0.dylib

    substituteInPlace generated/gtkd/gdkpixbuf/c/functions.d \
      --replace libgdk_pixbuf-2.0.so.0 ${gdk-pixbuf}/lib/libgdk_pixbuf-2.0.so.0 \
      --replace libgdk_pixbuf-2.0.0.dylib ${gdk-pixbuf}/lib/libgdk_pixbuf-2.0.0.dylib

    substituteInPlace generated/gtkd/gio/c/functions.d \
      --replace libgio-2.0.so.0 ${glib.out}/lib/libgio-2.0.so.0 \
      --replace libgio-2.0.0.dylib ${glib.out}/lib/libgio-2.0.0.dylib

    substituteInPlace generated/gtkd/glib/c/functions.d \
      --replace libglib-2.0.so.0 ${glib.out}/lib/libglib-2.0.so.0 \
      --replace libgmodule-2.0.so.0 ${glib.out}/lib/libgmodule-2.0.so.0 \
      --replace libgobject-2.0.so.0 ${glib.out}/lib/libgobject-2.0.so.0 \
      --replace libglib-2.0.0.dylib ${glib.out}/lib/libglib-2.0.0.dylib \
      --replace libgmodule-2.0.0.dylib ${glib.out}/lib/libgmodule-2.0.0.dylib \
      --replace libgobject-2.0.0.dylib ${glib.out}/lib/libgobject-2.0.0.dylib

    substituteInPlace generated/gtkd/gobject/c/functions.d \
      --replace libgobject-2.0.so.0 ${glib.out}/lib/libgobject-2.0.so.0 \
      --replace libgobject-2.0.0.dylib ${glib.out}/lib/libgobject-2.0.0.dylib

    substituteInPlace generated/gtkd/gtk/c/functions.d \
      --replace libgdk-3.so.0 ${gtk3}/lib/libgdk-3.so.0 \
      --replace libgtk-3.so.0 ${gtk3}/lib/libgtk-3.so.0 \
      --replace libgdk-3.0.dylib ${gtk3}/lib/libgdk-3.0.dylib \
      --replace libgtk-3.0.dylib ${gtk3}/lib/libgtk-3.0.dylib

    substituteInPlace generated/gtkd/pango/c/functions.d \
      --replace libpango-1.0.so.0 ${pango.out}/lib/libpango-1.0.so.0 \
      --replace libpangocairo-1.0.so.0 ${pango.out}/lib/libpangocairo-1.0.so.0 \
      --replace libpango-1.0.0.dylib ${pango.out}/lib/libpango-1.0.0.dylib \
      --replace libpangocairo-1.0.0.dylib ${pango.out}/lib/libpangocairo-1.0.0.dylib

    substituteInPlace generated/gtkd/rsvg/c/functions.d \
      --replace librsvg-2.so.2 ${librsvg}/lib/librsvg-2.so.2 \
      --replace librsvg-2.2.dylib ${librsvg}/lib/librsvg-2.2.dylib

    substituteInPlace generated/peas/peas/c/functions.d \
      --replace libpeas-1.0.so.0 ${libpeas}/lib/libpeas-1.0.so.0 \
      --replace libpeas-gtk-1.0.so.0 ${libpeas}/lib/libpeas-gtk-1.0.so.0 \
      --replace libpeas-1.0.0.dylib ${libpeas}/lib/libpeas-1.0.0.dylib \
      --replace gtk-1.0.0.dylib ${libpeas}/lib/gtk-1.0.0.dylib

    substituteInPlace generated/sourceview/gsv/c/functions.d \
      --replace libgtksourceview-4.so.0 ${gtksourceview4}/lib/libgtksourceview-4.so.0 \
      --replace libgtksourceview-4.0.dylib ${gtksourceview4}/lib/libgtksourceview-4.0.dylib

    substituteInPlace generated/vte/vte/c/functions.d \
      --replace libvte-2.91.so.0 ${vte}/lib/libvte-2.91.so.0 \
      --replace libvte-2.91.0.dylib ${vte}/lib/libvte-2.91.0.dylib
  '';

  makeFlags  = [
    "prefix=${placeholder "out"}"
    "PKG_CONFIG=${pkg-config}/bin/${pkg-config.targetPrefix}pkg-config"
  ];

  # The .pc files does not declare an `includedir=`, so the multiple
  # outputs setup hook misses this.
  postFixup = ''
    for pc in $dev/lib/pkgconfig/*; do
      substituteInPlace $pc \
        --replace "$out/include" "$dev/include"
    done
  '';

  passthru = {
    inherit dcompiler;
  };

  meta = with lib; {
    description = "D binding and OO wrapper for GTK";
    homepage = "https://gtkd.org";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
