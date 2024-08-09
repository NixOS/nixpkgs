{ fetchFromGitLab
, lib
, stdenv
, autoreconfHook
, fetchpatch2
, gtk-doc
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
  version = "1.14.52";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libgsf";
    rev = "LIBGSF_${lib.replaceStrings ["."] ["_"] version}";
    hash = "sha256-uSi2/pZiST07YutU8SHNoY2LifEQhohQeyaH9spyG2s=";
  };

  patches = [
    # Fixes building when nanohttp is not enabled in libxml2, which is the default since libxml2 2.13.
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/libgsf/-/commit/5d4bb55095d3d6ef793c1908a88504183e28644c.diff";
      hash = "sha256-2TF1KDUxJtSMTDze2/dOJQRkW8S1GA9OyFpYzYeKpjQ=";
    })
  ];

  postPatch = ''
    # Fix cross-compilation
    substituteInPlace configure.ac \
      --replace "AC_PATH_PROG(PKG_CONFIG, pkg-config, no)" \
                "PKG_PROG_PKG_CONFIG"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    gtk-doc
    pkg-config
    intltool
    libintl
  ];

  buildInputs = [
    gettext
    bzip2
    zlib
  ];

  nativeCheckInputs = [
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
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ lovek323 ];
    platforms = lib.platforms.unix;

    longDescription = ''
      Libgsf aims to provide an efficient extensible I/O abstraction for
      dealing with different structured file formats.
    '';
  };
}
