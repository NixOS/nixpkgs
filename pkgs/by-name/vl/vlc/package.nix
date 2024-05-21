{ lib
, SDL
, SDL_image
, a52dec
, alsa-lib
, autoreconfHook
, avahi
, dbus
, faad2
, fetchpatch
, fetchurl
, ffmpeg
, flac
, fluidsynth
, freefont_ttf
, freetype
, fribidi
, gnutls
, libSM
, libXext
, libXinerama
, libXpm
, libXv
, libXvMC
, libarchive
, libass
, libbluray
, libcaca
, libcddb
, libdc1394
, libdvbpsi
, libdvdnav
, libebml
, libgcrypt
, libgpg-error
, libjack2
, libkate
, libmad
, libmatroska
, libmicrodns
, libmodplug
, libmtp
, liboggz
, libopus
, libplacebo_5
, libpulseaudio
, libraw1394
, librsvg
, libsForQt5
, libsamplerate
, libspatialaudio
, libssh2
, libtheora
, libtiger
, libupnp
, libv4l
, libva
, libvdpau
, libvorbis
, libxml2
, live555
, lua5
, mpeg2dec
, ncurses
, perl
, pkg-config
, pkgsBuildBuild
, protobuf
, removeReferencesTo
, samba
, schroedinger
, speex
, srt
, stdenv
, systemd
, taglib
, unzip
, wayland
, wayland-protocols
, wrapGAppsHook3
, xcbutilkeysyms
, zlib

, chromecastSupport ? true
, jackSupport ? false
, onlyLibVLC ? false
, skins2Support ? !onlyLibVLC
, waylandSupport ? true
, withQt5 ? true
}:

# chromecastSupport requires TCP port 8010 to be open for it to work.
# If your firewall is enabled, make sure to have something like:
#   networking.firewall.allowedTCPPorts = [ 8010 ];

let
  inherit (lib) optionalString optionals;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${optionalString onlyLibVLC "lib"}vlc";
  version = "3.0.20";

  src = fetchurl {
    url = "https://get.videolan.org/vlc/${finalAttrs.version}/vlc-${finalAttrs.version}.tar.xz";
    hash = "sha256-rccoW00nIc3fQOtScMraKqoQozTLVG/VWgY1NEe6KbU=";
  };

  nativeBuildInputs = [
    autoreconfHook
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
    wayland
    wayland-protocols
  ];

  # VLC uses a *ton* of libraries for various pieces of functionality, many of
  # which are not included here for no other reason that nobody has mentioned
  # needing them
  buildInputs = [
    SDL
    SDL_image
    a52dec
    alsa-lib
    avahi
    dbus
    faad2
    ffmpeg
    flac
    fluidsynth
    fribidi
    gnutls
    libSM
    libXpm
    libXv
    libXvMC
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
    libkate
    libmad
    libmatroska
    libmodplug
    libmtp
    liboggz
    libopus
    libplacebo_5
    libpulseaudio
    libraw1394
    librsvg
    libsamplerate
    libspatialaudio
    libssh2
    libtheora
    libtiger
    libupnp
    libv4l
    libva
    libvdpau
    libvorbis
    libxml2
    lua5
    mpeg2dec
    ncurses
    samba
    schroedinger
    speex
    srt
    systemd
    taglib
    xcbutilkeysyms
    zlib
  ]
  ++ optionals (!stdenv.hostPlatform.isAarch && !onlyLibVLC) [ live555 ]
  ++ optionals jackSupport [ libjack2 ]
  ++ optionals chromecastSupport [ libmicrodns protobuf ]
  ++ optionals skins2Support [
    freetype
    libXext
    libXinerama
    libXpm
  ]
  ++ optionals waylandSupport [ wayland wayland-protocols ]
  ++ optionals withQt5 (with libsForQt5; [
    qtbase
    qtsvg
    qtx11extras
  ])
  ++ optionals (waylandSupport && withQt5) [ libsForQt5.qtwayland ];

  env = {
    # vlc depends on a c11-gcc wrapper script which we don't have so we need to
    # set the path to the compiler
    BUILDCC = "${pkgsBuildBuild.stdenv.cc}/bin/gcc";
    PKG_CONFIG_WAYLAND_SCANNER_WAYLAND_SCANNER = "wayland-scanner";
  } // lib.optionalAttrs (!stdenv.hostPlatform.isAarch) {
    LIVE555_PREFIX = live555;
  };

  patches = [
    # patch to build with recent live555
    # upstream issue: https://code.videolan.org/videolan/vlc/-/issues/25473
    (fetchpatch {
      url = "https://code.videolan.org/videolan/vlc/uploads/eb1c313d2d499b8a777314f789794f9d/0001-Add-lssl-and-lcrypto-to-liblive555_plugin_la_LIBADD.patch";
      hash = "sha256-qs3gY1ksCZlf931TSZyMuT2JD0sqrmcRCZwL+wVG0U8=";
    })
  ];

  postPatch = ''
    substituteInPlace modules/text_renderer/freetype/platform_fonts.h \
      --replace \
        /usr/share/fonts/truetype/freefont \
        ${freefont_ttf}/share/fonts/truetype
  ''
  # Upstream luac can't cross compile, so we have to install the lua sources
  # instead of bytecode:
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
    "--enable-srt" # Explicit enable srt to ensure the patch is applied.
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

  # fails on high core machines
  # ld: cannot find -lvlc_vdpau: No such file or directory
  # https://code.videolan.org/videolan/vlc/-/issues/27338
  enableParallelInstalling = false;

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
    find $out/lib/vlc/plugins -exec touch -d @1 '{}' ';'
    ${if stdenv.buildPlatform.canExecute stdenv.hostPlatform then "$out" else pkgsBuildBuild.libvlc}/lib/vlc/vlc-cache-gen $out/vlc/plugins
  '' + optionalString withQt5 ''
    remove-references-to -t "${libsForQt5.qtbase.dev}" $out/lib/vlc/plugins/gui/libqt_plugin.so
  '';

  meta = {
    description = "Cross-platform media player and streaming server";
    homepage = "https://www.videolan.org/vlc/";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
