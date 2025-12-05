{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  desktop-file-utils,
  gettext,
  pkg-config,
  meson,
  ninja,
  gnome,
  glib,
  gtk3,
  gtk4,
  gtkVersion ? "3",
  gobject-introspection,
  vala,
  python3,
  gi-docgen,
  libxml2,
  gnutls,
  gperf,
  pango,
  pcre2,
  cairo,
  fmt_11,
  fribidi,
  lz4,
  icu,
  simdutf,
  systemd,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  fast-float,
  nixosTests,
  blackbox-terminal,
  darwinMinVersionHook,
  withApp ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vte";
  version = "0.82.2";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optional (gtkVersion != null) "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/vte/${lib.versions.majorMinor finalAttrs.version}/vte-${finalAttrs.version}.tar.xz";
    hash = "sha256-4Slar8RoKztVDxI13CZ5uqD3FXDY7VQ8ABwSg9UwvpE=";
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

    # https://gitlab.gnome.org/GNOME/vte/-/merge_requests/11
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/vte/-/commit/f672ed15a88dd3e25c33aa0a5ef6f6d291a6d5c7.patch";
      hash = "sha256-JdLDild5j7marvR5n2heW9YD00+bwzJIoxDlzO5r/6w=";
    })

    (fetchpatch {
      name = "qemu-backspace.patch";
      url = "https://gitlab.gnome.org/GNOME/vte/-/commit/79d5fea437185e52a740130d5a276b83dfdcd558.patch";
      hash = "sha256-28Cehw5uJuGG7maLGUl1TBwfIwuXpkLKSQ2lXauLlz0=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils # for desktop-file-validate
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
    fmt_11
    fribidi
    gnutls
    pango # duplicated with propagatedBuildInputs to support gtkVersion == null
    pcre2
    lz4
    icu
    fast-float
    simdutf
  ]
  ++ lib.optionals systemdSupport [
    systemd
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (darwinMinVersionHook "13.3")
  ];

  # Required by vte-2.91.pc.
  propagatedBuildInputs = lib.optionals (gtkVersion != null) [
    (
      assert (gtkVersion == "3" || gtkVersion == "4");
      if gtkVersion == "3" then gtk3 else gtk4
    )
    glib
    pango
  ];

  mesonFlags = [
    "-Ddocs=true"
    (lib.mesonBool "app" withApp)
    (lib.mesonBool "gtk3" (gtkVersion == "3"))
    (lib.mesonBool "gtk4" (gtkVersion == "4"))
    (lib.mesonBool "_systemd" (!systemdSupport))
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # -Bsymbolic-functions is not supported on darwin
    "-D_b_symbolic_functions=false"
  ];

  # error: argument unused during compilation: '-pie' [-Werror,-Wunused-command-line-argument]
  env.NIX_CFLAGS_COMPILE = toString (
    lib.optional stdenv.hostPlatform.isMusl "-Wno-unused-command-line-argument"
    ++ lib.optional stdenv.cc.isClang "-Wno-cast-function-type-strict"
  );

  postPatch = ''
    patchShebangs perf/* \
      src/app/meson_desktopfile.py \
      src/parser-seq.py \
      src/minifont-coverage.py \
      src/modes.py
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
      inherit (nixosTests.terminal-emulators)
        gnome-terminal
        lxterminal
        mlterm
        roxterm
        sakura
        stupidterm
        terminator
        termite
        xfce4-terminal
        ;
      inherit blackbox-terminal;
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
    maintainers = with maintainers; [
      antono
    ];
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
})
