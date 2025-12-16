{
  lib,
  alsa-lib,
  autoreconfHook,
  avahi,
  bison,
  cairo,
  curl,
  dbus,
  faad2,
  fetchFromGitLab,
  fetchpatch,
  ffmpeg_7,
  flac,
  flex,
  fluidsynth,
  fontconfig,
  freefont_ttf,
  freetype,
  fribidi,
  gnutls,
  harfbuzz,
  libGL,
  libSM,
  libXext,
  libXinerama,
  libXpm,
  libarchive,
  libass,
  libbluray,
  libcaca,
  libcddb,
  libdc1394,
  libdvbpsi,
  libdvdnav,
  libebml,
  libgcrypt,
  libgpg-error,
  libjack2,
  libjpeg,
  libkate,
  libmad,
  libmatroska,
  libmicrodns,
  libmodplug,
  libmtp,
  libogg,
  libopus,
  libplacebo_5,
  libpng,
  libpulseaudio,
  librsvg,
  libsForQt5,
  libsamplerate,
  libspatialaudio,
  libssh2,
  libtheora,
  libtiger,
  libupnp,
  libv4l,
  libva,
  libvorbis,
  libxml2,
  live555,
  lua5,
  ncurses,
  nix-update-script,
  perl,
  pkg-config,
  pkgsBuildBuild,
  protobuf,
  removeReferencesTo,
  samba,
  schroedinger,
  speex,
  srt,
  stdenv,
  systemdLibs,
  taglib_1,
  unzip,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wrapGAppsHook3,
  writeShellScript,
  xcbutilkeysyms,
  zlib,

  chromecastSupport ? true,
  jackSupport ? false,
  onlyLibVLC ? false,
  skins2Support ? !onlyLibVLC,
  waylandSupport ? true,
  withQt5 ? true,
}:

# chromecastSupport requires TCP port 8010 to be open for it to work.
# If your firewall is enabled, make sure to have something like:
#   networking.firewall.allowedTCPPorts = [ 8010 ];

let
  inherit (lib) optionalString optionals;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${optionalString onlyLibVLC "lib"}vlc";
  version = "3.0.22";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = "vlc";
    rev = finalAttrs.version;
    hash = "sha256-EI8w8Nep8Vhgp+5wKOdtbFHiSkURnGqb/AjTfELTq1w=";
  };

  depsBuildBuild = optionals waylandSupport [ pkg-config ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    lua5
    perl
    pkg-config
    removeReferencesTo
    unzip
    wrapGAppsHook3
  ]
  ++ optionals chromecastSupport [ protobuf ]
  ++ optionals withQt5 [ libsForQt5.wrapQtAppsHook ]
  ++ optionals waylandSupport [
    wayland-scanner
  ];

  # VLC uses a *ton* of libraries for various pieces of functionality, many of
  # which are not included here for no other reason that nobody has mentioned
  # needing them
  buildInputs = [
    alsa-lib
    avahi
    cairo
    dbus
    faad2
    ffmpeg_7
    flac
    fluidsynth
    fontconfig
    freetype
    fribidi
    gnutls
    harfbuzz
    libGL
    libSM
    libarchive
    libass
    libbluray
    libcaca
    libcddb
    libdc1394
    libdvbpsi
    libdvdnav
    libdvdnav.libdvdread
    libebml
    libgcrypt
    libgpg-error
    libjpeg
    libkate
    libmad
    libmatroska
    libmodplug
    libmtp
    libogg
    libopus
    libplacebo_5
    libpng
    libpulseaudio
    librsvg
    libsamplerate
    libspatialaudio
    libssh2
    libtheora
    libtiger
    libupnp
    libv4l
    libva
    libvorbis
    libxml2
    lua5
    ncurses
    samba
    schroedinger
    speex
    srt
    systemdLibs
    taglib_1
    xcbutilkeysyms
    zlib
  ]
  ++ optionals (!onlyLibVLC) [ live555 ]
  ++ optionals jackSupport [ libjack2 ]
  ++ optionals chromecastSupport [
    libmicrodns
    protobuf
  ]
  ++ optionals skins2Support [
    libXext
    libXinerama
    libXpm
  ]
  ++ optionals waylandSupport [
    wayland
    wayland-protocols
  ]
  ++ optionals withQt5 (
    with libsForQt5;
    [
      qtbase
      qtsvg
      qtx11extras
    ]
  )
  ++ optionals (waylandSupport && withQt5) [ libsForQt5.qtwayland ];
  strictDeps = true;

  env = {
    # vlc searches for c11-gcc, c11, c99-gcc, c99, which don't exist and would be wrong for cross compilation anyway.
    BUILDCC = "${pkgsBuildBuild.stdenv.cc}/bin/gcc";
    LIVE555_PREFIX = live555;
  }
  // lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  patches = [
    # patch to build with recent live555
    # upstream issue: https://code.videolan.org/videolan/vlc/-/issues/25473
    (fetchpatch {
      url = "https://code.videolan.org/videolan/vlc/uploads/eb1c313d2d499b8a777314f789794f9d/0001-Add-lssl-and-lcrypto-to-liblive555_plugin_la_LIBADD.patch";
      hash = "sha256-qs3gY1ksCZlf931TSZyMuT2JD0sqrmcRCZwL+wVG0U8=";
    })
    # make the plugins.dat file generation reproducible
    # upstream merge request: https://code.videolan.org/videolan/vlc/-/merge_requests/7149
    ./deterministic-plugin-cache.diff
  ];

  postPatch = ''
    echo "$version" > src/revision.txt
    substituteInPlace modules/text_renderer/freetype/platform_fonts.h \
      --replace \
        /usr/share/fonts/truetype/freefont \
        ${freefont_ttf}/share/fonts/truetype
  ''
  # Upstream luac can't cross compile, so we have to install the lua sources
  # instead of bytecode, which was built for buildPlatform:
  # https://www.lua.org/wshop13/Jericke.pdf#page=39
  + lib.optionalString (!stdenv.hostPlatform.canExecute stdenv.buildPlatform) ''
    substituteInPlace share/Makefile.am \
      --replace $'.luac \\\n' $'.lua \\\n'
  '';

  enableParallelBuilding = true;

  dontWrapGApps = true; # to prevent double wrapping of Qtwrap and Gwrap

  # Most of the libraries are auto-detected so we don't need to set a bunch of
  # "--enable-foo" flags here
  configureFlags = [
    "--with-kde-solid=$out/share/apps/solid/actions"
  ]
  ++ optionals onlyLibVLC [ "--disable-vlc" ]
  ++ optionals skins2Support [ "--enable-skins2" ]
  ++ optionals waylandSupport [ "--enable-wayland" ]
  ++ optionals chromecastSupport [
    "--enable-sout"
    "--enable-chromecast"
    "--enable-microdns"
  ];

  # Remove runtime dependencies on libraries
  postConfigure = ''
    sed -i 's|^#define CONFIGURE_LINE.*$|#define CONFIGURE_LINE "<removed>"|g' config.h
  '';

  # Add missing SOFA files
  # Given in EXTRA_DIST, but not in install-data target
  postInstall = ''
    cp -R share/hrtfs $out/share/vlc
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # - Touch plugins (plugins cache keyed off mtime and file size:
  #     https://github.com/NixOS/nixpkgs/pull/35124#issuecomment-370552830
  # - Remove references to the Qt development headers (used in error messages)
  #
  # pkgsBuildBuild is used here because buildPackages.libvlc somehow
  # depends on a qt5.qttranslations that doesn't build, even though it
  # should be the same as pkgsBuildBuild.qt5.qttranslations.
  postFixup = ''
    patchelf --add-rpath ${libv4l}/lib "$out/lib/vlc/plugins/access/libv4l2_plugin.so"
    find $out/lib/vlc/plugins -exec touch -d @1 '{}' ';'
    ${
      if stdenv.buildPlatform.canExecute stdenv.hostPlatform then "$out" else pkgsBuildBuild.libvlc
    }/lib/vlc/vlc-cache-gen $out/vlc/plugins
  ''
  + optionalString withQt5 ''
    remove-references-to -t "${libsForQt5.qtbase.dev}" $out/lib/vlc/plugins/gui/libqt_plugin.so
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform media player and streaming server";
    homepage = "https://www.videolan.org/vlc/";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ alois31 ];
    platforms = lib.platforms.linux;
    mainProgram = "vlc";
  };
})
