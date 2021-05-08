{ fetchurl, lib, stdenv, pkg-config, clutter, gtk3, glib, cogl, gnome, gdk-pixbuf }:

stdenv.mkDerivation rec {
  pname = "clutter-gst";
  version = "3.0.27";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "17czmpl92dzi4h3rn5rishk015yi3jwiw29zv8qan94xcmnbssgy";
  };

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
    platforms = lib.platforms.gnu ++ lib.platforms.linux;  # arbitrary choice
  };
}
