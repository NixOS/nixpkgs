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

  chromecastSupport ? true,
  jackSupport ? false,
  onlyLibVLC ? false,
  skins2Support ? withQt6 && !onlyLibVLC,
  waylandSupport ? true,
  withQt6 ? !onlyLibVLC,
}:

# chromecastSupport requires TCP port 8010 to be open.
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
    # Make plugins.dat independent of filesystem traversal order.
    # https://code.videolan.org/videolan/vlc/-/merge_requests/7149
    ./deterministic-plugin-cache.diff

    # Avoid an assertion when CUDA and OpenGL use different GPUs.
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

  # VLC detects optional features from the libraries available here.
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

  # The archive timestamps break test_libvlc_media; --disable-vlc omits the
  # executable and external preparser required by the other two tests.
  checkFlags = [
    "XFAIL_TESTS=${
      toString (
        [ "test_libvlc_media" ]
        ++ optionals onlyLibVLC [
          "test/run_vlc.sh"
          "test_src_preparser_cmp_internal_external"
        ]
      )
    }"
  ];

  enableParallelBuilding = true;
  enableParallelChecking = false;

  # https://code.videolan.org/videolan/vlc/-/issues/27338
  enableParallelInstalling = false;

  env = {
    # VLC searches for non-existent c17/c11/c99 compiler wrappers otherwise.
    BUILDCC = lib.getExe pkgsBuildBuild.stdenv.cc;
  }
  // lib.optionalAttrs (!onlyLibVLC) {
    LIVE555_PREFIX = live555;
  };

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

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
  # Lua bytecode is architecture-dependent, so install sources when crossing.
  + optionalString (!stdenv.hostPlatform.canExecute stdenv.buildPlatform) ''
    substituteInPlace share/Makefile.am \
      --replace-fail \
        'nobase_pkglibexec_SCRIPTS += $(LUA_MODULES:%.lua=%.luac)' \
        'nobase_pkglibexec_SCRIPTS += $(LUA_MODULES)'
  '';

  # Do not retain the build-time configure command in the output.
  postConfigure = ''
    sed -i 's|^#define CONFIGURE_LINE.*$|#define CONFIGURE_LINE "<removed>"|g' config.h
  '';

  preCheck = optionalString withQt6 ''
    export HOME=$TMPDIR
    export QT_QPA_PLATFORM=offscreen
    export NIXPKGS_QT6_QML_IMPORT_PATH=${qtEnv}/${qt6.qtbase.qtQmlPrefix}
    export QML2_IMPORT_PATH=$NIXPKGS_QT6_QML_IMPORT_PATH
    export FONTCONFIG_FILE=${fontconfig}/etc/fonts/fonts.conf
  '';

  # Listed in EXTRA_DIST, but omitted from the install target.
  postInstall = ''
    cp -R share/hrtfs $out/share/vlc
    rm $out/share/vlc/utils/{audio,video}-vlc-default.sh
  '';

  postFixup = ''
    patchelf --add-rpath ${libaacs}/lib "$out/lib/vlc/plugins/access/liblibbluray_plugin.so"
    patchelf --add-rpath ${libv4l}/lib "$out/lib/vlc/plugins/access/libv4l2_plugin.so"
    while IFS= read -r -d "" plugin; do
      addDriverRunpath "$plugin"
    done < <(find "$out/lib/vlc/plugins" -name '*nvdec*.so' -print0)

    # The plugin cache is keyed by mtime and file size.
    find "$out/lib/vlc/plugins" -exec touch -d @1 '{}' +
    rm -f "$out/lib/vlc/plugins/plugins.dat"
  ''
  + optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    "$out/libexec/vlc/vlc-cache-gen" "$out/lib/vlc/plugins"
  ''
  + optionalString withQt6 ''
    remove-references-to -t "${qt6.qtbase.dev}" "$out/lib/vlc/plugins/gui/libqt_plugin.so"
  ''
  + optionalString (withQt6 && !onlyLibVLC) ''
    # qtEnv includes development outputs needed to build, not to run.
    filteredQtWrapperArgs=()
    for ((i = 0; i < ''${#qtWrapperArgs[@]}; i += 4)); do
      if [[ "''${qtWrapperArgs[i + 3]}" != ${qtEnv}/* ]]; then
        filteredQtWrapperArgs+=("''${qtWrapperArgs[@]:i:4}")
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
    maintainers = with lib.maintainers; [ aaravrav ];
    platforms = lib.platforms.linux;
  }
  // lib.optionalAttrs (!onlyLibVLC) {
    mainProgram = "vlc";
  };
})
