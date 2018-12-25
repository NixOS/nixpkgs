{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, libxml2
, desktop-file-utils, python3, wrapGAppsHook , gtk, gnome3, gnome-autoar
, glib-networking, shared-mime-info, libnotify, libexif, libseccomp , exempi
, librsvg, tracker, tracker-miners, gexiv2, libselinux, gdk_pixbuf
, substituteAll, bubblewrap
}:

let
  pname = "nautilus";
  version = "3.30.5";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "144r4py9b8w9ycsg6fggjg05kwvymh003qsb3h6apgpch5y3zgnv";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig libxml2 gettext python3 wrapGAppsHook
    desktop-file-utils
  ];

  buildInputs = [
    glib-networking shared-mime-info libexif gtk exempi libnotify libselinux
    tracker tracker-miners gexiv2 libseccomp bubblewrap
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
