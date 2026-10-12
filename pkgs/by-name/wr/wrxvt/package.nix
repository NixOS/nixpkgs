{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  copyDesktopItems,
  makeDesktopItem,
  libev,
  libx11,
  libxt,
  libxft,
  libxrender,
  libxext,
  ncurses,
  fontconfig,
  freetype,
  harfbuzz,
  gdk-pixbuf,
  openssl,
  perl,
  libptytty,
  nixosTests,
  perlSupport ? true,
  gdkPixbufSupport ? true,
  emojiSequences ? true,
  shareTls ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wrxvt";
  version = "9.32";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "hydrastro";
    repo = "wrxvt";
    rev = "bf07902da01c13b5fccd88a61c12ffb831959981";
    hash = "sha256-ILZgxImjzY6EiXTXO4eolCHr7nVC5XCPySUPfOXEXTA=";
  };

  # rxvt-unicode compiles libev in from libev/, a separate CVS module that
  # isn't in the repository; nixpkgs' libev source is the same release
  postUnpack = ''
    tar -xzf ${libev.src}
    mv libev-${libev.version} "$sourceRoot/libev"
  '';

  outputs = [
    "out"
    "terminfo"
  ];

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    libx11
    libxt
    libxft
    libxrender
    ncurses # tic, for the terminfo output
    fontconfig
    freetype
    libptytty
  ]
  ++ lib.optionals perlSupport [
    perl
    libxext
  ]
  ++ lib.optional gdkPixbufSupport gdk-pixbuf
  ++ lib.optional emojiSequences harfbuzz
  ++ lib.optional shareTls openssl;

  configureFlags = [
    "--with-terminfo=${placeholder "terminfo"}/share/terminfo"
    "--enable-everything"
    "--enable-256-color"
    (lib.enableFeature perlSupport "perl")
    (lib.enableFeature gdkPixbufSupport "pixbuf")
    (lib.enableFeature emojiSequences "emoji-sequences")
    (lib.enableFeature shareTls "share-tls")
    "CXXFLAGS=-std=c++17"
  ];

  env = {
    LDFLAGS = toString [
      "-lfontconfig"
      "-lXrender"
      "-lpthread"
    ];
    CFLAGS = "-I${freetype.dev}/include/freetype2";
  };

  preConfigure = ''
    # tic writes the terminfo entry here (see man tic)
    mkdir -p $terminfo/share/terminfo
    export TERMINFO=$terminfo/share/terminfo
  ''
  + lib.optionalString perlSupport ''
    # the perl library ends up on PERL5LIB through lib/perl5/site_perl
    mkdir -p $out/$(dirname ${perl.libPrefix})
    ln -s $out/lib/urxvt $out/${perl.libPrefix}
  '';

  enableParallelBuilding = true;

  desktopItems = [
    (makeDesktopItem {
      name = "wrxvt";
      exec = "wrxvt";
      icon = "utilities-terminal";
      comment = finalAttrs.meta.description;
      desktopName = "wrxvt";
      genericName = "Terminal";
      categories = [
        "System"
        "TerminalEmulator"
      ];
    })
  ];

  postInstall = ''
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  passthru.tests.test = nixosTests.terminal-emulators.wrxvt;

  meta = {
    description = "rxvt-unicode improved";
    longDescription = ''
      wrxvt is rxvt-unicode with what newer terminals do: sixel and kitty
      pictures (Unicode placeholders too), the kitty keyboard protocol,
      OSC 8 hyperlinks, OSC 52, synchronized output, grapheme clusters
      (mode 2027), shell integration (OSC 7 and 133), 24-bit colour,
      underline styles, sharing the terminal on a web page, asciinema
      recordings and keyboard hints, keeping rxvt-unicode's speed, its
      perl extensions and its daemon.
    '';
    homepage = "https://github.com/hydrastro/wrxvt";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hydrastro ];
    platforms = lib.platforms.linux;
    mainProgram = "wrxvt";
  };
})
