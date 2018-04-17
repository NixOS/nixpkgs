{ stdenv, fetchurl, meson, ninja, intltool, gst_all_1, clutter
, clutter-gtk, clutter-gst, python3Packages, shared-mime-info
, pkgconfig, gtk3, glib, gobjectIntrospection
, bash, wrapGAppsHook, itstool, libxml2, vala, gnome3, librsvg
, gdk_pixbuf, tracker, nautilus }:

stdenv.mkDerivation rec {
  name = "totem-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/totem/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "e32fb9a68097045e75c87ad1b8177f5c01aea2a13dcb3b2e71a0f9570fe9ee13";
  };

  doCheck = true;

  # https://bugs.launchpad.net/ubuntu/+source/totem/+bug/1712021
  # https://bugzilla.gnome.org/show_bug.cgi?id=784236
  # https://github.com/mesonbuild/meson/issues/1994
  enableParallelBuilding = false;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [ meson ninja vala pkgconfig intltool python3Packages.python itstool wrapGAppsHook ];
  buildInputs = [
    gtk3 glib gnome3.grilo clutter-gtk clutter-gst gnome3.totem-pl-parser gnome3.grilo-plugins
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly gst_all_1.gst-libav gnome3.libpeas shared-mime-info
    gdk_pixbuf libxml2 gnome3.defaultIconTheme gnome3.gnome-desktop
    gnome3.gsettings-desktop-schemas tracker nautilus
  ];

  propagatedBuildInputs = [ gobjectIntrospection python3Packages.pylint python3Packages.pygobject2 ];

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

  wrapPrefixVariables = [ "PYTHONPATH" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "totem";
      attrPath = "gnome3.totem";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Movie player for the GNOME desktop based on GStreamer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
