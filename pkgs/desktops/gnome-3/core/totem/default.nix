{ stdenv, fetchurl, meson, ninja, intltool, gst_all_1, clutter
, clutter_gtk, clutter-gst, python3Packages, shared_mime_info
, pkgconfig, gtk3, glib, gobjectIntrospection
, bash, wrapGAppsHook, itstool, libxml2, dbus_glib, vala, gnome3, librsvg
, gdk_pixbuf, file, tracker, nautilus }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [ meson ninja vala pkgconfig intltool python3Packages.python itstool file wrapGAppsHook ];
  buildInputs = [ gtk3 glib gnome3.grilo clutter_gtk clutter-gst gnome3.totem-pl-parser gnome3.grilo-plugins
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
                  gst_all_1.gst-plugins-ugly gst_all_1.gst-libav gnome3.libpeas shared_mime_info dbus_glib
                  gdk_pixbuf libxml2 gnome3.defaultIconTheme gnome3.gnome_desktop
                  gnome3.gsettings_desktop_schemas tracker nautilus ];

  propagatedBuildInputs = [ gobjectIntrospection python3Packages.pylint python3Packages.pygobject2 ];

  checkPhase = "meson test";

  patches = [
    (fetchurl {
      name = "remove-pycompile.patch";
      url = "https://bug787965.bugzilla-attachments.gnome.org/attachment.cgi?id=360204";
      sha256 = "1iphlazllv42k553jqh3nqrrh5jb63gy3nhj4ipwc9xh4sg2irhi";
    })
  ];

  postPatch = ''
    chmod +x meson_compile_python.py meson_post_install.py # patchShebangs requires executable file
    patchShebangs .
  '';

  mesonFlags = [ "-Dwith-nautilusdir=lib/nautilus/extensions-3.0" ];

  GI_TYPELIB_PATH = "$out/lib/girepository-1.0";
  wrapPrefixVariables = [ "PYTHONPATH" ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Movie player for the GNOME desktop based on GStreamer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
