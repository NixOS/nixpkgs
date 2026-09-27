{
  lib,
  stdenv,
  addDriverRunpath,
  a52dec,
  alsa-lib,
  aribb24,
  autoreconfHook,
  avahi,
  bison,
  cairo,
  chromaprint,
  dav1d,
  dbus,
  faad2,
  fetchFromGitLab,
  ffmpeg,
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
  libaacs,
  libarchive,
  libass,
  libavc1394,
  libbluray-full,
  libcaca,
  libdc1394,
  libdrm,
  libdvbpsi,
  libdvdnav,
  libebml,
  libgbm,
  libgcrypt,
  libgpg-error,
  libjack2,
  libjpeg,
  libkate,
  libmad,
  libmatroska,
  libmicrodns,
  libmodplug,
  libmpg123,
  libmtp,
  libnfs,
  libnotify,
  libogg,
  libopus,
  libplacebo,
  libpng,
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
  libx11,
  libxcb,
  libxcb-keysyms,
  libxcursor,
  libxext,
  libxinerama,
  libxkbcommon,
  libxml2,
  libxpm,
  live555,
  lua5,
  ncurses,
  nix-update,
  nv-codec-headers-12,
  perl,
  pipewire,
  pkg-config,
  pkgsBuildBuild,
  protobuf,
  python3,
  qt6,
  removeReferencesTo,
  samba,
  shine,
  speex,
  srt,
  systemdLibs,
  taglib,
  testers,
  twolame,
  unzip,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wrapGAppsHook3,
  writeShellScript,
  x264,
  x265,
  zlib,
  zvbi,

  # chromecastSupport requires TCP port 8010 to be open
  # If your firewall is enabled, make sure to have something like:
  #   networking.firewall.allowedTCPPorts = [ 8010 ];
  chromecastSupport ? true,
  jackSupport ? false,
  onlyLibVLC ? false,
  skins2Support ? withQt6 && !onlyLibVLC,
  waylandSupport ? true,
  withQt6 ? !onlyLibVLC,
}:

let
  inherit (lib) optionalString optionals;
  qtModules = [
    qt6.qtdeclarative
    qt6.qtshadertools
    qt6.qtsvg
  ]
  ++ optionals waylandSupport [ qt6.qtwayland ];
  qtEnv = qt6.env "vlc4-qtdeps" qtModules;
  qtRuntimeModules = map lib.getLib ([ qt6.qtbase ] ++ qtModules);
  qtPluginPath = lib.makeSearchPath qt6.qtbase.qtPluginPrefix qtRuntimeModules;
  qtQmlPath = lib.makeSearchPath qt6.qtbase.qtQmlPrefix qtRuntimeModules;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${optionalString onlyLibVLC "lib"}vlc";
  version = "3.0.23-2-unstable-2026-08-31";

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = "vlc";
    rev = "d22301a881428c5bdc86141ff05d039c9a2885a9";
    hash = "sha256-VAeFXoqwQGkSeNrCF5+vi/GHAnUS0l2kvSrXor6YStA=";
  };

  patches = [
    # Sort plugins to make plugins.dat deterministic
    # https://code.videolan.org/videolan/vlc/-/merge_requests/7149
    ./deterministic-plugin-cache.diff

    # Clean up failed NVDEC/OpenGL interop to prevent crashes when decoding and
    # rendering use different GPUs
    # https://code.videolan.org/videolan/vlc/-/merge_requests/8644
    ./nvdec-gl-cleanup.diff
  ];

  __structuredAttrs = true;
  strictDeps = true;

  depsBuildBuild = optionals waylandSupport [ pkg-config ];

  nativeBuildInputs = [
    addDriverRunpath
    autoreconfHook
    bison
    flex
    lua5
    perl
    pkg-config
    python3
    removeReferencesTo
    unzip
    wrapGAppsHook3
  ]
  ++ optionals chromecastSupport [ protobuf ]
  ++ optionals withQt6 [
    qtEnv
    qt6.wrapQtAppsHook
  ]
  ++ optionals waylandSupport [ wayland-scanner ];

  buildInputs = [
    a52dec
    alsa-lib
    aribb24
    avahi
    cairo
    chromaprint
    dav1d
    dbus
    faad2
    ffmpeg
    flac
    fluidsynth
    fontconfig
    freetype
    fribidi
    gnutls
    harfbuzz
    libGL
    libaacs
    libarchive
    libass
    libavc1394
    libbluray-full
    libcaca
    libdc1394
    libdrm
    libdvbpsi
    libdvdnav
    libdvdnav.libdvdread
    libebml
    libgbm
    libgcrypt
    libgpg-error
    libjpeg
    libkate
    libmad
    libmatroska
    libmodplug
    libmpg123
    libmtp
    libnfs
    libnotify
    libogg
    libopus
    libplacebo
    libpng
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
    libx11
    libxcb
    libxcb-keysyms
    libxkbcommon
    libxml2
    lua5
    ncurses
    nv-codec-headers-12
    pipewire
    samba
    shine
    speex
    srt
    systemdLibs
    taglib
    twolame
    x264
    x265
    zlib
    zvbi
  ]
  ++ optionals (!onlyLibVLC) [ live555 ]
  ++ optionals jackSupport [ libjack2 ]
  ++ optionals chromecastSupport [
    libmicrodns
    protobuf
  ]
  ++ optionals skins2Support [
    libxcursor
    libxext
    libxinerama
    libxpm
  ]
  ++ optionals waylandSupport [
    wayland
    wayland-protocols
  ]
  ++ optionals withQt6 [
    qtEnv
    qt6.qtbase
  ];

  nativeInstallCheckInputs = optionals (
    !onlyLibVLC && stdenv.buildPlatform.canExecute stdenv.hostPlatform
  ) [ ffmpeg ];

  # Most of the libraries are auto-detected so we don't need to set a bunch of
  # "--enable-foo" flags here
  configureFlags = [
    "--enable-nvdec"
    "--with-kde-solid=${placeholder "out"}/share/apps/solid/actions"
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

  # These tests require the omitted VLC executable and external preparser
  checkFlags = optionals onlyLibVLC [
    "XFAIL_TESTS=test/run_vlc.sh test_src_preparser_cmp_internal_external"
  ];

  enableParallelBuilding = true;
  enableParallelChecking = false;

  # fails on high core machines
  # ld: cannot find -lvlc_vdpau: No such file or directory
  # https://code.videolan.org/videolan/vlc/-/issues/27338
  enableParallelInstalling = false;

  env = {
    # vlc depends on a c11-gcc wrapper script which we don't have so we need to
    # set the path to the compiler
    BUILDCC = lib.getExe pkgsBuildBuild.stdenv.cc;
  }
  // lib.optionalAttrs (!onlyLibVLC) {
    LIVE555_PREFIX = live555;
  };

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  doInstallCheck = !onlyLibVLC && stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  dontUseQmakeConfigure = true;
  dontWrapGApps = true;
  dontWrapQtApps = true;

  postPatch = ''
    echo ${finalAttrs.src.rev} > src/revision.txt
    substituteInPlace configure.ac \
      --replace-fail "date '+%Y-%m-%d'" \
        "echo '${lib.last (lib.splitString "-unstable-" finalAttrs.version)}'"
    substituteInPlace modules/text_renderer/freetype/platform_fonts.h \
      --replace-fail \
        /usr/share/fonts/truetype/freefont \
        ${freefont_ttf}/share/fonts/truetype
  ''
  # Upstream luac cannot cross-compile, so install Lua sources instead of
  # build-platform bytecode
  # https://www.lua.org/wshop13/Jericke.pdf#page=39
  + optionalString (!stdenv.hostPlatform.canExecute stdenv.buildPlatform) ''
    substituteInPlace share/Makefile.am \
      --replace-fail \
        'nobase_pkglibexec_SCRIPTS += $(LUA_MODULES:%.lua=%.luac)' \
        'nobase_pkglibexec_SCRIPTS += $(LUA_MODULES)'
  '';

  # Remove runtime dependencies on libraries
  postConfigure = ''
    sed -i 's|^#define CONFIGURE_LINE.*$|#define CONFIGURE_LINE "<removed>"|g' config.h
  '';

  preCheck = ''
    # test_libvlc_media requires mtimes at least as recent as the commit that
    # added these fixtures; fetched sources have their timestamps normalized
    find test/samples/subitems -exec touch -d @1446796477 '{}' +
  ''
  + optionalString withQt6 ''
    export HOME=$TMPDIR
    export QT_QPA_PLATFORM=offscreen
    export NIXPKGS_QT6_QML_IMPORT_PATH=${qtEnv}/${qt6.qtbase.qtQmlPrefix}
    export QML2_IMPORT_PATH=$NIXPKGS_QT6_QML_IMPORT_PATH
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
  '';

  # Add missing SOFA files
  # Given in EXTRA_DIST, but not in install-data target
  postInstall = ''
    cp -R share/hrtfs $out/share/vlc
    # The default-association scripts use hard-coded /usr paths, so remove them
    rm $out/share/vlc/utils/{audio,video}-vlc-default.sh
  '';

  # - Remove references to the Qt development headers (used in error messages)
  # - Touch plugins (plugins cache keyed off mtime and file size):
  #     https://github.com/NixOS/nixpkgs/pull/35124#issuecomment-370552830
  postFixup = ''
    patchelf --add-rpath ${libaacs}/lib "$out/lib/vlc/plugins/access/liblibbluray_plugin.so"
    patchelf --add-rpath ${libv4l}/lib "$out/lib/vlc/plugins/access/libv4l2_plugin.so"
    while IFS= read -r -d "" plugin; do
      addDriverRunpath "$plugin"
    done < <(find "$out/lib/vlc/plugins" -name '*nvdec*.so' -print0)
  ''
  + optionalString withQt6 ''
    remove-references-to -t "${qt6.qtbase.dev}" "$out/lib/vlc/plugins/gui/libqt_plugin.so"
  ''
  + ''
    find "$out/lib/vlc/plugins" -exec touch -d @1 '{}' +
    rm -f "$out/lib/vlc/plugins/plugins.dat"
  ''
  + optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    "$out/libexec/vlc/vlc-cache-gen" "$out/lib/vlc/plugins"
  ''
  + optionalString (withQt6 && !onlyLibVLC) ''
    # qtEnv includes build-only development outputs, so exclude its paths from
    # the runtime wrapper
    filteredQtWrapperArgs=()
    for ((i = 0; i < ''${#qtWrapperArgs[@]}; )); do
      if ((i + 3 < ''${#qtWrapperArgs[@]})) &&
        [[ "''${qtWrapperArgs[i]}" == --prefix &&
          ( "''${qtWrapperArgs[i + 1]}" == QT_PLUGIN_PATH ||
            "''${qtWrapperArgs[i + 1]}" == NIXPKGS_QT6_QML_IMPORT_PATH ) &&
          "''${qtWrapperArgs[i + 2]}" == : &&
          "''${qtWrapperArgs[i + 3]}" == ${qtEnv}/* ]]; then
        ((i += 4))
      else
        filteredQtWrapperArgs+=("''${qtWrapperArgs[i]}")
        ((i += 1))
      fi
    done
    qtWrapperArgs=(
      "''${filteredQtWrapperArgs[@]}"
      --prefix QT_PLUGIN_PATH : "${qtPluginPath}"
      --prefix NIXPKGS_QT6_QML_IMPORT_PATH : "${qtQmlPath}"
    )
    wrapQtApp "$out/bin/vlc" "''${gappsWrapperArgs[@]}"
  ''
  + optionalString (!withQt6 && !onlyLibVLC) ''
    wrapGApp "$out/bin/vlc"
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    set -o pipefail

    if ! test -s "$out/lib/vlc/plugins/plugins.dat"; then
      echo "VLC plugins cache is missing or empty" >&2
      exit 1
    fi

    testDir="$TMPDIR/vlc-playback-test"
    mkdir -p "$testDir"/{home,cache}
    # VLC's file audio output writes signed 16-bit samples in native byte order
    pcmFormat=${if stdenv.hostPlatform.isBigEndian then "s16be" else "s16le"}

    ffmpeg -nostdin -hide_banner -loglevel error \
      -f lavfi -i "testsrc2=size=64x64:rate=2:duration=1" \
      -c:v libvpx-vp9 -pix_fmt yuv420p -an "$testDir/video.webm"
    ffmpeg -nostdin -hide_banner -loglevel error \
      -f lavfi -i "sine=frequency=440:sample_rate=44100:duration=1" \
      -ac 1 -c:a "pcm_$pcmFormat" -f "$pcmFormat" "$testDir/reference.pcm"
    ffmpeg -nostdin -hide_banner -loglevel error \
      -f "$pcmFormat" -ar 44100 -ac 1 -i "$testDir/reference.pcm" \
      -c:a flac "$testDir/audio.flac"
    ffmpeg -nostdin -hide_banner -loglevel error \
      -f lavfi -i "testsrc2=size=64x64:rate=2:duration=1" \
      -f "$pcmFormat" -ar 44100 -ac 1 -i "$testDir/reference.pcm" \
      -c:v libx264 -preset ultrafast -pix_fmt yuv420p -c:a aac -shortest "$testDir/av.mp4"

    export HOME="$testDir/home"
    export XDG_CACHE_HOME="$testDir/cache"

    runVLC() {
      timeout 30 "$out/bin/cvlc" --ignore-config --no-dbus --no-media-library --dec-dev=none \
        "$@" vlc://quit 2>&1 | tee -a "$testDir/vlc.log"
    }

    # Exercise streaming/transcoding as well as the normal playback path
    runVLC -A adummy -V vdummy \
      --sout "#transcode{vcodec=I420}:std{access=file,mux=raw,dst=$testDir/video.yuv}" \
      "$testDir/video.webm"
    runVLC -V vdummy -A file --audiofile-file="$testDir/audio.pcm" \
      --audiofile-format=s16 --audiofile-channels=1 --no-audiofile-wav \
      "$testDir/audio.flac"
    runVLC --no-drop-late-frames --no-video-title-show --no-osd \
      -V yuv --yuv-file="$testDir/playback.yuv" --yuv-chroma=I420 \
      -A file --audiofile-file="$testDir/playback.pcm" \
      --audiofile-format=s16 --audiofile-channels=1 --no-audiofile-wav \
      "$testDir/av.mp4"

    if grep -Fq "stale plugins cache" "$testDir/vlc.log"; then
      echo "VLC reported a stale plugins cache" >&2
      exit 1
    fi
    test -s "$testDir/reference.pcm"
    cmp "$testDir/reference.pcm" "$testDir/audio.pcm"
    # Require decoded output without depending on frame redraws or AAC padding
    test -s "$testDir/video.yuv"
    test -s "$testDir/playback.yuv"
    test -s "$testDir/playback.pcm"

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = writeShellScript "update-vlc4" ''
      set -eu -o pipefail
      nixpkgs=$(git rev-parse --show-toplevel)
      package="$nixpkgs/pkgs/by-name/vl/vlc4/package.nix"
      ${lib.getExe nix-update} "$UPDATE_NIX_ATTR_PATH" \
        --file "$nixpkgs" \
        --override-filename "$package" \
        --version=branch
    '';
  }
  // lib.optionalAttrs (!onlyLibVLC) {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "4.0.0-dev";
    };
  };

  meta = {
    description = "Cross-platform media player and streaming server";
    homepage = "https://www.videolan.org/vlc/";
    donationPage = "https://www.videolan.org/contribute.html#money";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [
      aaravrav
      nick-linux
    ];
    platforms = lib.platforms.linux;
  }
  // lib.optionalAttrs (!onlyLibVLC) {
    mainProgram = "vlc";
  };
})
