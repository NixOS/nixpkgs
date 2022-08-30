{ fetchFromGitLab
, lib
, stdenv
, autoreconfHook
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
  version = "1.14.50";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libgsf";
    rev = "LIBGSF_${lib.replaceStrings ["."] ["_"] version}";
    hash = "sha256-6RP2DJWcDQ8dkKtcPxAkRsS7jSvvLoDNZHXiDJwR8Eg=";
  };

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
