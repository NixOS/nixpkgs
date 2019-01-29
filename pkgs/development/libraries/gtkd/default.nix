{ stdenv, fetchzip, atk, cairo, dmd, gdk_pixbuf, gnome3, gst_all_1, librsvg
, pango, pkgconfig, which, vte }:

stdenv.mkDerivation rec {
  name = "gtkd-${version}";
  version = "3.8.5";

  src = fetchzip {
    url = "https://gtkd.org/Downloads/sources/GtkD-${version}.zip";
    sha256 = "12n2njsaplra7x15nqwrj2hrf8a27pfjj2mck4mkzxv03qk6mqky";
    stripRoot = false;
  };

  nativeBuildInputs = [ dmd pkgconfig which ];
  propagatedBuildInputs = [
    atk cairo gdk_pixbuf glib gstreamer gst_plugins_base gtk3 gtksourceview
    libgda libpeas librsvg pango vte
  ];

  prePatch = ''
    substituteAll ${./paths.d} generated/gtkd/gtkd/paths.d
    substituteInPlace src/cairo/c/functions-compiletime.d \
      --replace libcairo.so.2 ${cairo}/lib/libcairo.so.2 \
      --replace libcairo.dylib ${cairo}/lib/libcairo.dylib
    substituteInPlace src/cairo/c/functions-runtime.d \
      --replace libcairo.so.2 ${cairo}/lib/libcairo.so.2 \
      --replace libcairo.dylib ${cairo}/lib/libcairo.dylib
    substituteInPlace generated/gtkd/gdkpixbuf/c/functions.d \
      --replace libgdk_pixbuf-2.0.so.0 ${gdk_pixbuf}/lib/libgdk_pixbuf-2.0.so.0 \
      --replace libgdk_pixbuf-2.0.0.dylib ${gdk_pixbuf}/lib/libgdk_pixbuf-2.0.0.dylib
    substituteInPlace generated/gtkd/atk/c/functions.d \
      --replace libatk-1.0.so.0 ${atk}/lib/libatk-1.0.so.0 \
      --replace libatk-1.0.0.dylib ${atk}/lib/libatk-1.0.0.dylib
    substituteInPlace generated/gtkd/pango/c/functions.d \
      --replace libpango-1.0.so.0 ${pango.out}/lib/libpango-1.0.so.0 \
      --replace libpangocairo-1.0.so.0 ${pango.out}/lib/libpangocairo-1.0.so.0 \
      --replace libpango-1.0.0.dylib ${pango.out}/lib/libpango-1.0.0.dylib \
      --replace libpangocairo-1.0.0.dylib ${pango.out}/lib/libpangocairo-1.0.0.dylib
    substituteInPlace generated/gtkd/gobject/c/functions.d \
      --replace libgobject-2.0.so.0 ${glib.out}/lib/libgobject-2.0.so.0 \
      --replace libgobject-2.0.0.dylib ${glib.out}/lib/libgobject-2.0.0.dylib
    substituteInPlace generated/gtkd/rsvg/c/functions.d \
      --replace librsvg-2.so.2 ${librsvg}/lib/librsvg-2.so.2 \
      --replace librsvg-2.2.dylib ${librsvg}/lib/librsvg-2.2.dylib
    substituteInPlace generated/gtkd/cairo/c/functions.d \
      --replace libcairo.so.2 ${cairo}/lib/libcairo.so.2 \
      --replace libcairo.dylib ${cairo}/lib/libcairo.dylib
    substituteInPlace generated/gtkd/gdk/c/functions.d \
      --replace libgdk-3.so.0 ${gtk3}/lib/libgdk-3.so.0 \
      --replace libgdk-3.0.dylib ${gtk3}/lib/libgdk-3.0.dylib
    substituteInPlace generated/peas/peas/c/functions.d \
      --replace libpeas-1.0.so.0 ${libpeas}/lib/libpeas-1.0.so.0 \
      --replace libpeas-gtk-1.0.so.0 ${libpeas}/lib/libpeas-gtk-1.0.so.0 \
      --replace libpeas-1.0.0.dylib ${libpeas}/lib/libpeas-1.0.0.dylib \
      --replace gtk-1.0.0.dylib ${libpeas}/lib/gtk-1.0.0.dylib
    substituteInPlace generated/vte/vte/c/functions.d \
      --replace libvte-2.91.so.0 ${vte}/lib/libvte-2.91.so.0 \
      --replace libvte-2.91.0.dylib ${vte}/lib/libvte-2.91.0.dylib
    substituteInPlace generated/gstreamer/gstinterfaces/c/functions.d \
      --replace libgstvideo-1.0.so.0 ${gst_plugins_base}/lib/libgstvideo-1.0.so.0 \
      --replace libgstvideo-1.0.0.dylib ${gst_plugins_base}/lib/libgstvideo-1.0.0.dylib
    substituteInPlace generated/sourceview/gsv/c/functions.d \
      --replace libgtksourceview-3.0.so.1 ${gtksourceview}/lib/libgtksourceview-3.0.so.1 \
      --replace libgtksourceview-3.0.1.dylib ${gtksourceview}/lib/libgtksourceview-3.0.1.dylib
    substituteInPlace generated/gtkd/glib/c/functions.d \
      --replace libglib-2.0.so.0 ${glib.out}/lib/libglib-2.0.so.0 \
      --replace libgmodule-2.0.so.0 ${glib.out}/lib/libgmodule-2.0.so.0 \
      --replace libgobject-2.0.so.0 ${glib.out}/lib/libgobject-2.0.so.0 \
      --replace libglib-2.0.0.dylib ${glib.out}/lib/libglib-2.0.0.dylib \
      --replace libgmodule-2.0.0.dylib ${glib.out}/lib/libgmodule-2.0.0.dylib \
      --replace libgobject-2.0.0.dylib ${glib.out}/lib/libgobject-2.0.0.dylib
    substituteInPlace generated/gtkd/gio/c/functions.d \
      --replace libgio-2.0.so.0 ${glib.out}/lib/libgio-2.0.so.0 \
      --replace libgio-2.0.0.dylib ${glib.out}/lib/libgio-2.0.0.dylib
    substituteInPlace generated/gstreamer/gstreamer/c/functions.d \
      --replace libgstreamer-1.0.so.0 ${gstreamer}/lib/libgstreamer-1.0.so.0 \
      --replace libgstreamer-1.0.0.dylib ${gstreamer}/lib/libgstreamer-1.0.0.dylib
    substituteInPlace generated/gtkd/gtk/c/functions.d \
      --replace libgdk-3.so.0 ${gtk3}/lib/libgdk-3.so.0 \
      --replace libgtk-3.so.0 ${gtk3}/lib/libgtk-3.so.0 \
      --replace libgdk-3.0.dylib ${gtk3}/lib/libgdk-3.0.dylib \
      --replace libgtk-3.0.dylib ${gtk3}/lib/libgtk-3.0.dylib
  '';

  installFlags = "prefix=$(out)";

  # Workaround for https://github.com/NixOS/nixpkgs/issues/40397
  # Remove after update to binutils 2.31
  dontStrip = true;

  inherit atk cairo gdk_pixbuf librsvg pango;
  inherit (gnome3) glib gtk3 gtksourceview libgda libpeas;
  inherit (gst_all_1) gstreamer;
  gst_plugins_base = gst_all_1.gst-plugins-base;

  meta = with stdenv.lib; {
    description = "D binding and OO wrapper for GTK+";
    homepage = https://gtkd.org;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
