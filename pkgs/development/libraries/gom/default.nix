{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, glib
, python3
, sqlite
, gdk-pixbuf
, gnome3
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "gom";
  version = "0.4";

  outputs = [ "out" "py" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "17ca07hpg7dqxjn0jpqim3xqcmplk2a87wbwrrlq3dd3m8381l38";
  };

  patches = [
    ./longer-stress-timeout.patch
  ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    sqlite
    python3.pkgs.pygobject3
  ];

  mesonFlags = [
    "-Dpygobject-override-dir=${placeholder "py"}/${python3.sitePackages}/gi/overrides"
  ];

  # Success is more likely on x86_64
  doCheck = stdenv.isx86_64;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A GObject to SQLite object mapper";
    homepage = "https://wiki.gnome.org/Projects/Gom";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
