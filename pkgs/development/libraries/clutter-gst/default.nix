{ fetchurl, fetchpatch, lib, stdenv, pkg-config, clutter, gtk3, glib, cogl, gnome, gdk-pixbuf }:

stdenv.mkDerivation rec {
  pname = "clutter-gst";
  version = "3.0.27";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "17czmpl92dzi4h3rn5rishk015yi3jwiw29zv8qan94xcmnbssgy";
  };

  patches = [
    # Add patch from Arch Linux to fix corrupted display with Cheese
    # https://gitlab.gnome.org/GNOME/cheese/-/issues/51
    # https://github.com/archlinux/svntogit-packages/tree/packages/clutter-gst/trunk
    (fetchpatch {
      url = "https://github.com/archlinux/svntogit-packages/raw/c4dd0bbda35aa603ee790676f6e15541f71b6d36/trunk/0001-video-sink-Remove-RGBx-BGRx-support.patch";
      sha256 = "sha256-k1fCiM/u7q81UrDYgbqhN/C+q9DVQ+qOyq6vmA3hbSQ=";
    })
  ];

  propagatedBuildInputs = [ clutter gtk3 glib cogl gdk-pixbuf ];
  nativeBuildInputs = [ pkg-config ];

  postBuild = "rm -rf $out/share/gtk-doc";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "GStreamer bindings for clutter";

    homepage = "http://www.clutter-project.org/";

    license = lib.licenses.lgpl2Plus;

    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
}
