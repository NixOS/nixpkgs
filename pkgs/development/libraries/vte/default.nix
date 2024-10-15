{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gettext
, pkg-config
, meson
, ninja
, gnome
, glib
, gtk3
, gtk4
, gtkVersion ? "3"
, gobject-introspection
, vala
, python3
, gi-docgen
, libxml2
, gnutls
, gperf
, pango
, pcre2
, cairo
, fribidi
, lz4
, icu
, systemd
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd
, nixosTests
, blackbox-terminal
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vte";
  version = "0.78.0";

  outputs = [ "out" "dev" ]
    ++ lib.optional (gtkVersion != null) "devdoc";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "vte";
    rev = finalAttrs.version;
    hash = "sha256-Ql4q30Q4OEyH63SMbpMVyT/ZySeH/5b+5vo+Xv2HGdQ=";
  };

  patches = [
    # VTE needs a small patch to work with musl:
    # https://gitlab.gnome.org/GNOME/vte/issues/72
    # Taken from https://git.alpinelinux.org/aports/tree/community/vte3
    (fetchpatch {
      name = "0001-Add-W_EXITCODE-macro-for-non-glibc-systems.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/vte3/fix-W_EXITCODE.patch?id=4d35c076ce77bfac7655f60c4c3e4c86933ab7dd";
      hash = "sha256-FkVyhsM0mRUzZmS2Gh172oqwcfXv6PyD6IEgjBhy2uU=";
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
    gi-docgen
  ];

  buildInputs = [
    cairo
    fribidi
    gnutls
    pango # duplicated with propagatedBuildInputs to support gtkVersion == null
    pcre2
    lz4
    icu
  ] ++ lib.optionals systemdSupport [
    systemd
  ];

  # Required by vte-2.91.pc.
  propagatedBuildInputs = lib.optionals (gtkVersion != null) [
    (assert (gtkVersion == "3" || gtkVersion == "4");
    if gtkVersion == "3" then gtk3 else gtk4)
    glib
    pango
  ];

  mesonFlags = [
    "-Ddocs=true"
    (lib.mesonBool "gtk3" (gtkVersion == "3"))
    (lib.mesonBool "gtk4" (gtkVersion == "4"))
  ] ++ lib.optionals (!systemdSupport) [
    "-D_systemd=false"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # -Bsymbolic-functions is not supported on darwin
    "-D_b_symbolic_functions=false"
  ];

  # error: argument unused during compilation: '-pie' [-Werror,-Wunused-command-line-argument]
  env.NIX_CFLAGS_COMPILE = toString (lib.optional stdenv.hostPlatform.isMusl "-Wno-unused-command-line-argument"
    ++ lib.optional stdenv.cc.isClang "-Wno-cast-function-type-strict");

  postPatch = ''
    patchShebangs perf/*
    patchShebangs src/parser-seq.py
    patchShebangs src/minifont-coverage.py
    patchShebangs src/modes.py
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "vte";
      versionPolicy = "odd-unstable";
    };
    tests = {
      inherit (nixosTests.terminal-emulators) gnome-terminal lxterminal mlterm roxterm sakura stupidterm terminator termite xfce4-terminal;
      blackbox-terminal = blackbox-terminal.override { sixelSupport = true; };
    };
  };

  meta = with lib; {
    homepage = "https://www.gnome.org/";
    description = "Library implementing a terminal emulator widget for GTK";
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
})
