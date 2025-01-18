{
  lib,
  SDL,
  SDL_image,
  a52dec,
  alsa-lib,
  aribb24,
  autoreconfHook,
  avahi,
  bison,
  chromaprint,
  dav1d,
  dbus,
  faad2,
  fetchFromGitLab,
  fetchpatch,
  ffmpeg,
  flac,
  flex,
  fluidsynth,
  freefont_ttf,
  freetype,
  fribidi,
  gnutls,
  libSM,
  libXext,
  libXinerama,
  libXpm,
  libXv,
  libXvMC,
  libarchive,
  libass,
  libavc1394,
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
  libkate,
  libmad,
  libmatroska,
  libmicrodns,
  libmodplug,
  libmpg123,
  libmtp,
  libnfs,
  libnotify,
  liboggz,
  libopus,
  libplacebo_5,
  libpulseaudio,
  libraw1394,
  librsvg,
  libsamplerate,
  libsecret,
  libspatialaudio,
  libssh2,
  libtheora,
  libtiger,
  libupnp,
  libv4l,
  libva,
  libvdpau,
  libvorbis,
  libxml2,
  live555,
  lua5,
  mesa,
  mpeg2dec,
  ncurses,
  nix-update,
  perl,
  pipewire,
  pkg-config,
  pkgsBuildBuild,
  protobuf_21,
  python3,
  qt6Packages,
  removeReferencesTo,
  samba,
  schroedinger,
  shine,
  speex,
  srt,
  stdenv,
  systemd,
  taglib,
  twolame,
  unzip,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wrapGAppsHook3,
  writeShellScript,
  x264,
  x265,
  xcbutilkeysyms,
  zlib,
  zvbi,

  chromecastSupport ? true,
  jackSupport ? false,
  onlyLibVLC ? false,
  skins2Support ? !onlyLibVLC,
  waylandSupport ? true,
  withQt6 ? true,
}:

# chromecastSupport requires TCP port 8010 to be open for it to work.
# If your firewall is enabled, make sure to have something like:
#   networking.firewall.allowedTCPPorts = [ 8010 ];

let
  inherit (lib) optionals optional;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vlc4";
  version = "4.0.0-unstable-2024-12-29";

  src = fetchFromGitLab {
    owner = "videolan";
    repo = "vlc";
    rev = "dc430c6528d805ad57b6c2b1bd6a746ef2de12a8";
    domain = "code.videolan.org";
    hash = "sha256-5RTQrWaJHL+whq+WOuW5+9XHrF6jayjWJtKusPNNnhU=";
  };

  nativeBuildInputs =
    [
      autoreconfHook
      lua5
      perl
      pkg-config
      removeReferencesTo
      unzip
      wrapGAppsHook3
    ]
    ++ optionals chromecastSupport [ protobuf_21 ]
    ++ optionals withQt6 [ qt6Packages.wrapQtAppsHook ]
    ++ optionals waylandSupport [
      wayland-scanner
    ];

  # VLC uses a *ton* of libraries for various pieces of functionality, many of
  # which are not included here for no other reason that nobody has mentioned
  # needing them
  buildInputs =
    [
      SDL
      SDL_image
      a52dec
      alsa-lib
      aribb24
      avahi
      bison
      chromaprint
      dav1d
      dbus
      faad2
      ffmpeg
      flac
      flex
      fluidsynth
      fribidi
      gnutls
      libSM
      libXpm
      libXv
      libXvMC
      libarchive
      libass
      libavc1394
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
      libmpg123
      libmtp
      libnfs
      libnotify
      liboggz
      libopus
      libplacebo_5
      libpulseaudio
      libraw1394
      librsvg
      libsamplerate
      libsecret
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
      mesa
      mpeg2dec
      ncurses
      pipewire
      python3
      samba
      schroedinger
      shine
      speex
      srt
      systemd
      taglib
      twolame
      x264
      x265
      xcbutilkeysyms
      zlib
      zvbi
    ]
    ++ optionals (!stdenv.hostPlatform.isAarch && !onlyLibVLC) [ live555 ]
    ++ optionals jackSupport [ libjack2 ]
    ++ optionals chromecastSupport [
      libmicrodns
      protobuf_21
    ]
    ++ optionals skins2Support [
      freetype
      libXext
      libXinerama
      libXpm
    ]
    ++ optionals waylandSupport [
      wayland
      wayland-protocols
    ]
    ++ optionals withQt6 [
      (qt6Packages.env "vlc4-qtdeps" (
        with qt6Packages;
        [
          qtsvg
          qtshadertools
          qtdeclarative
        ]
        ++ optional waylandSupport qtwayland
      ))
      qt6Packages.qtbase
    ];

  env =
    {
      # vlc depends on a c11-gcc wrapper script which we don't have so we need to
      # set the path to the compiler
      BUILDCC = "${pkgsBuildBuild.stdenv.cc}/bin/gcc";
      PKG_CONFIG_WAYLAND_SCANNER_WAYLAND_SCANNER = "wayland-scanner";
    }
    // lib.optionalAttrs stdenv.cc.isGNU {
      NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
    }
    // lib.optionalAttrs (!stdenv.hostPlatform.isAarch) {
      LIVE555_PREFIX = live555;
    };

  patches = [
    # patch to build with recent live555
    # upstream issue: https://code.videolan.org/videolan/vlc/-/issues/25473
    # (the issue got closed, but the build still fails if we remove this patch)
    (fetchpatch {
      url = "https://code.videolan.org/videolan/vlc/uploads/eb1c313d2d499b8a777314f789794f9d/0001-Add-lssl-and-lcrypto-to-liblive555_plugin_la_LIBADD.patch";
      hash = "sha256-qs3gY1ksCZlf931TSZyMuT2JD0sqrmcRCZwL+wVG0U8=";
    })
  ];

  postPatch =
    ''
      substituteInPlace modules/text_renderer/freetype/platform_fonts.h \
        --replace-fail \
          /usr/share/fonts/truetype/freefont \
          ${freefont_ttf}/share/fonts/truetype
    ''
    # Upstream luac can't cross compile, so we have to install the lua sources
    # instead of bytecode:
    # https://www.lua.org/wshop13/Jericke.pdf#page=39
    # TODO doesn't work
    + lib.optionalString (!stdenv.hostPlatform.canExecute stdenv.buildPlatform) ''
      substituteInPlace share/Makefile.am \
        --replace-fail $'.luac \\\n' $'.lua \\\n'
    '';

  enableParallelBuilding = true;

  dontWrapGApps = true; # to prevent double wrapping of Qtwrap and Gwrap

  # Most of the libraries are auto-detected so we don't need to set a bunch of
  # "--enable-foo" flags here
  configureFlags =
    [
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
    ]
    ++ optionals (!withQt6) [ "--disable-qt" ];

  preConfigure = ''
    echo ${finalAttrs.src.rev} > src/revision.txt
    ./bootstrap
  '';

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
  postFixup =
    ''
      # unwrap everything in $out/libexec (qt wraps it and it is hardcoded behaviour)
      # https://github.com/NixOS/nixpkgs/blob/10f4a9ab7541ca6a76f8a98a7cd5fae70a425f7e/pkgs/development/libraries/qt-6/hooks/wrap-qt-apps-hook.sh#L77
      for file in $(find "$out/libexec" ! -type d -executable -not -path '*/.*'); do
        [ -L "$file" ] && echo "WARN $file"
        echo "unwrapping $file"
        hidden="$(dirname "$file")/.$(basename "$file")"-wrapped
        mv "$hidden" "$file"
      done
      find $out/lib/vlc/plugins -exec touch -d @1 '{}' ';'
      ${
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then "$out" else pkgsBuildBuild.libvlc
      }/libexec/vlc/vlc-cache-gen $out/vlc/plugins
    ''
    + lib.optionalString withQt6 ''
      remove-references-to -t "${qt6Packages.qtbase.dev}" $out/lib/vlc/plugins/gui/libqt_plugin.so
    '';

  passthru.updateScript = writeShellScript "update-vlc4.sh" ''
    set -exu -o pipefail
    ${lib.getExe nix-update} --version=branch vlc4
    sed -i 's/3\.0\..\+-unstable/4.0.0-unstable/' pkgs/by-name/vl/vlc4/package.nix
  '';

  meta = {
    description = "Cross-platform media player and streaming server";
    homepage = "https://www.videolan.org/vlc/";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      alois31
      perchun
    ];
    platforms = lib.platforms.linux;
    mainProgram = "vlc";
  };
})
