{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, libxml2
, desktop-file-utils, python3, wrapGAppsHook , gtk3, gnome3, gnome-autoar
, glib-networking, shared-mime-info, libnotify, libexif, libseccomp , exempi
, librsvg, tracker, tracker-miners, gexiv2, libselinux, gdk_pixbuf
, substituteAll, bubblewrap, gst_all_1
}:

let
  pname = "nautilus";
  version = "3.32.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1pnh32fal7dkwadga5savg1nv0zqnbakhk0hxr5726087i6y6ii2";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig libxml2 gettext python3 wrapGAppsHook
    desktop-file-utils
  ];

  buildInputs = [
    glib-networking shared-mime-info libexif gtk3 exempi libnotify libselinux
    tracker tracker-miners gexiv2 libseccomp bubblewrap gst_all_1.gst-plugins-base
    gnome3.adwaita-icon-theme gnome3.gsettings-desktop-schemas
  ];

  propagatedBuildInputs = [ gnome-autoar ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk_pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  patches = [
    ./extension_dir.patch
    # 3.30 now generates it's own thummbnails,
    # and no longer depends on `gnome-desktop`
    (substituteAll {
      src = ./bubblewrap-paths.patch;
      bubblewrap_bin = "${bubblewrap}/bin/bwrap";
      inherit (builtins) storeDir;
    })
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "The file manager for GNOME";
    homepage = https://wiki.gnome.org/Apps/Files;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
