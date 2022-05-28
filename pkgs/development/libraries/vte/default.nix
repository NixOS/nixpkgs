{ stdenv
, lib
, fetchurl
, fetchpatch
, gettext
, pkg-config
, meson
, ninja
, gnome
, glib
, gtk3
, gobject-introspection
, vala
, python3
, libxml2
, gnutls
, gperf
, pango
, pcre2
, fribidi
, zlib
, icu
, systemd
, systemdSupport ? stdenv.hostPlatform.isLinux
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "vte";
  version = "0.68.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-E+fUeJyiFqM3gAMNJGybE92/0ECUxjFu6n/5IoTdF0k=";
  };

  patches = [
    # VTE needs a small patch to work with musl:
    # https://gitlab.gnome.org/GNOME/vte/issues/72
    # Taken from https://git.alpinelinux.org/aports/tree/community/vte3
    (fetchpatch {
      name = "0001-Add-W_EXITCODE-macro-for-non-glibc-systems.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/vte3/fix-W_EXITCODE.patch?id=4d35c076ce77bfac7655f60c4c3e4c86933ab7dd";
      sha256 = "FkVyhsM0mRUzZmS2Gh172oqwcfXv6PyD6IEgjBhy2uU=";
    })
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    gperf
    libxml2
    meson
    ninja
    pkg-config
    vala
    python3
  ];

  buildInputs = [
    fribidi
    gnutls
    pcre2
    zlib
    icu
  ] ++ lib.optionals systemdSupport [
    systemd
  ];

  propagatedBuildInputs = [
    # Required by vte-2.91.pc.
    gtk3
    glib
    pango
  ];

  mesonFlags = lib.optionals (!systemdSupport) [
    "-D_systemd=false"
  ];

  postPatch = ''
    patchShebangs perf/*
    patchShebangs src/box_drawing_generate.sh
    patchShebangs src/parser-seq.py
    patchShebangs src/modes.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
    tests = {
      inherit (nixosTests.terminal-emulators) gnome-terminal lxterminal mlterm roxterm sakura stupidterm terminator termite xfce4-terminal;
    };
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://www.gnome.org/";
    description = "A library implementing a terminal emulator widget for GTK";
    longDescription = ''
      VTE is a library (libvte) implementing a terminal emulator widget for
      GTK, and a minimal sample application (vte) using that.  Vte is
      mainly used in gnome-terminal, but can also be used to embed a
      console/terminal in games, editors, IDEs, etc. VTE supports Unicode and
      character set conversion, as well as emulating any terminal known to
      the system's terminfo database.
    '';
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ astsmtl antono ] ++ teams.gnome.members;
    platforms = platforms.unix;
  };
}
