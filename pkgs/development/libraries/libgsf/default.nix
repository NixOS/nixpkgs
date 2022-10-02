{ fetchurl
, lib
, stdenv
, pkg-config
, intltool
, gettext
, glib
, libxml2
, zlib
, bzip2
, perl
, gdk-pixbuf
, libiconv
, libintl
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libgsf";
  version = "1.14.50";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "bmwg0HeDOQadWDwNY3WdKX6BfqENDYl+u+ll8W4ujlI=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    libintl
  ];

  buildInputs = [
    gettext
    bzip2
    zlib
  ];

  checkInputs = [
    perl
  ];

  propagatedBuildInputs = [
    libxml2
    glib
    gdk-pixbuf
    libiconv
  ];

  doCheck = true;

  preCheck = ''
    patchShebangs ./tests/
  '';

  # checking pkg-config is at least version 0.9.0... ./configure: line 15213: no: command not found
  # configure: error: in `/build/libgsf-1.14.50':
  # configure: error: The pkg-config script could not be found or is too old.  Make sure it
  # is in your PATH or set the PKG_CONFIG environment variable to the full
  preConfigure = ''
    export PKG_CONFIG="$(command -v "$PKG_CONFIG")"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "GNOME's Structured File Library";
    homepage = "https://www.gnome.org/projects/libgsf";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms = lib.platforms.unix;

    longDescription = ''
      Libgsf aims to provide an efficient extensible I/O abstraction for
      dealing with different structured file formats.
    '';
  };
}
