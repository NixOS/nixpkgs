{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  meson,
  ninja,
  python3,
  pkg-config,
  rustc,
  cargo,
  cargo-c,
  lld,
  nasm,
  cmake,
  libGL,
  gstreamer,
  gst-plugins-base,
  gst-plugins-good,
  gst-plugins-bad,
  gst-plugins-ugly,
  gtk4,
  cairo,
  csound,
  dav1d,
  libsodium,
  libwebp,
  openssl,
  pango,

  jq,
  writeTextFile,
  validatePkgConfig,
  testers,
  nix-update-script,
  # specifies a limited subset of plugins to build (the default `null` means all plugins supported on the stdenv platform)
  plugins ? null,
  withGtkPlugins ? true,
  # Checks meson.is_cross_build(), so even canExecute isn't enough.
  enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform && plugins == null,
  hotdoc,
  apple-sdk_gstreamer,
}:

let
  # checked against upstream meson_options.txt in postConfigure
  # ordered according plugin list in README.md for readability
  # validate plugin is excluded here and in the verification script below
  validPlugins = {
    # generic
    file = [ ];
    gopbuffer = [ ];
    inter = [ ];
    originalbuffer = [ ];
    streamgrouper = [ ];
    sodium = [ libsodium ];
    threadshare = [ ];

    # net
    aws = [ openssl ];
    deepgram = [ ];
    hlsmultivariantsink = [ ];
    hlssink3 = [ ];
    icecast = [ ];
    mpegtslive = [ ];
    ndi = [ ];
    onvif = [ pango ];
    quinn = [ ];
    raptorq = [ ];
    reqwest = [ openssl ];
    rtp = [ ];
    rtsp = [ ];
    webrtc = [
      gst-plugins-bad
      openssl
    ];
    webrtchttp = [
      gst-plugins-bad
      openssl
    ];

    # audio
    audiofx = [ ];
    audioparsers = [ ];
    claxon = [ ];
    csound = [ csound ];
    demucs = [ ];
    elevenlabs = [ ];
    lewton = [ ];
    speechmatics = [ ];
    spotify = [ ];
    whisper = [ ];

    # video
    cdg = [ ];
    closedcaption = [ pango ];
    dav1d = [ dav1d ];
    ffv1 = [ ];
    gif = [ ];
    gtk4 = [ gtk4 ];
    hsv = [ ];
    png = [ ];
    rav1e = [ ];
    skia = [ ];
    videofx = [ cairo ];
    # would require libvvdec
    vvdec = [ ];
    webp = [ libwebp ];

    # mux
    flavors = [ ];
    isobmff = [ ];

    # text
    textaccumulate = [ ];
    textahead = [ ];
    json = [ ];
    regex = [ ];
    textwrap = [ ];

    # utils
    fallbackswitch = [ gtk4 ];
    livesync = [ gtk4 ];
    togglerecord = [ gtk4 ];
    tracers = [ ];
    uriplaylistbin = [ ];
    debugseimetainserter = [ ];

    # analytics
    analytics = [ gst-plugins-bad ];
    burn = [ ];
  };

  selectedPlugins =
    if plugins != null then
      lib.unique (lib.sort lib.lessThan plugins)
    else
      lib.subtractLists (
        [
          # tests have weird failure on x86, does not currently work on arm or darwin
          # csound rust package currently incompatible with csound >= 7.x
          "csound"

          # test failures
          "isobmff"
          "webrtc"

          "vvdec" # libvvdec not currently packaged
          "skia" # skia-bindings requires configuration to link against system libraries
        ]
        ++ lib.optionals stdenv.hostPlatform.isAarch64 [
          "raptorq" # pointer alignment failure in tests on aarch64
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          "reqwest" # tests hang on darwin
          "threadshare" # tests cannot bind to localhost on darwin
          "uriplaylistbin" # thread reqwest-internal-sync-runtime attempred to create a NULL object (in test_cache)
          "webp" # not supported on darwin (upstream crate issue)
        ]
        ++ lib.optionals (!gst-plugins-base.glEnabled || !withGtkPlugins) [
          # these require gstreamer-gl
          "gtk4"
          "livesync"
          "fallbackswitch"
          "togglerecord"
        ]
      ) (lib.attrNames validPlugins);

  rsPrefixedPlugins = [
    "analytics"
    "audiofx"
    "audioparsers"
    "closedcaption"
    "file"
    "inter"
    "onvif"
    "png"
    "rtp"
    "rtsp"
    "tracers"
    "videofx"
    "webp"
    "webrtc"
  ];

  pkgConfigName =
    name:
    if name == "flavors" then
      "gstrsflv"
    else
      (if lib.elem name rsPrefixedPlugins then "gstrs${name}" else "gst${name}");
  pkgConfigNames = map pkgConfigName selectedPlugins;

  invalidPlugins = lib.subtractLists (lib.attrNames validPlugins) selectedPlugins;

  validPluginFile = writeTextFile {
    name = "known-plugin-names.txt";
    text = lib.concatLines (lib.attrNames validPlugins);
  };

  # aws-lc-rs has no pregenerated bindings for exotic platforms
  # https://aws.github.io/aws-lc-rs/platform_support.html
  # whisper requires bindgen
  requiresBindgen =
    !(stdenv.hostPlatform.isx86 || stdenv.hostPlatform.isAarch64) || lib.elem "whisper" selectedPlugins;
in
assert lib.assertMsg (invalidPlugins == [ ])
  "Invalid gst-plugins-rs plugin${
    lib.optionalString (lib.length invalidPlugins > 1) "s"
  }: ${lib.concatStringsSep ", " invalidPlugins}";

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-plugins-rs";
  version = "0.15.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "gstreamer";
    repo = "gst-plugins-rs";
    rev = finalAttrs.version;
    hash = "sha256-DO5Dk9xjqWTI4ORzlHYPc/O/tyHfSyh7+YCzES5ZiHs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "gst-plugins-rs-${finalAttrs.version}";
    hash = "sha256-EHikshVeaBzyx9+GBIkOPii63T12BobWdW6nTBLzwU8=";
  };

  postConfigure = ''
    meson introspect . --buildoptions | \
      jq -r 'map(select(.description | test("Build .+ plugin")) | .name | select(. != "validate")) | sort | .[]' \
      > valid-plugin-names.txt
    echo "checking for consistency between validPlugins and meson_options.txt"
    diff -u ${validPluginFile} valid-plugin-names.txt
  '';

  patches = [
    ./doctest-fixes.patch
  ];

  postPatch = ''
    patchShebangs cargo_wrapper.py dependencies.py
  '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    meson
    ninja
    python3
    python3.pkgs.tomli
    pkg-config
    rustc
    cargo
    cargo-c
    jq
    nasm
    validatePkgConfig
  ]
  ++ lib.optionals requiresBindgen [
    cmake
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    lld
  ]
  ++ lib.optionals enableDocumentation [
    hotdoc
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin { NIX_CFLAGS_LINK = "-fuse-ld=lld"; };

  buildInputs = [
    gstreamer
    gst-plugins-base
    libGL
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_gstreamer
  ]
  ++ lib.concatMap (plugin: lib.getAttr plugin validPlugins) selectedPlugins;

  checkInputs = [
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ];

  mesonFlags = (map (plugin: lib.mesonEnable plugin true) selectedPlugins) ++ [
    (lib.mesonOption "sodium-source" "system")
    (lib.mesonEnable "tests" finalAttrs.finalPackage.doCheck)
    (lib.mesonEnable "doc" enableDocumentation)
  ];

  # turn off all auto plugins since we use a list of plugins we generate
  mesonAutoFeatures = "disabled";

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # csound lib dir must be manually specified for it to build
  preConfigure = lib.optionalString (lib.elem "csound" selectedPlugins) ''
    export CSOUND_LIB_DIR=${lib.getLib csound}/lib
  '';

  mesonCheckFlags = [ "--verbose" ];

  # required for icecast tests
  __darwinAllowLocalNetworking =
    finalAttrs.finalPackage.doCheck && lib.elem "icecast" selectedPlugins;

  preCheck = ''
    # Fontconfig error: No writable cache directories
    export XDG_CACHE_HOME="$(mktemp -d)"
    export GST_PLUGIN_PATH="$(realpath "target/${stdenv.hostPlatform.rust.cargoShortTarget}/$cargoBuildType")"
    export GST_PLUGIN_SCANNER="${lib.getLib gstreamer}/libexec/gstreamer-1.0/gst-plugin-scanner"
  '';

  postInstall = ''
    install -Dm444 -t ''${!outputDev}/lib/pkgconfig plugins/gst*.pc
  '';

  doInstallCheck =
    (lib.elem "webp" selectedPlugins) && !stdenv.hostPlatform.isStatic && stdenv.hostPlatform.isElf;
  installCheckPhase = ''
    runHook preInstallCheck
    readelf -a $out/lib/gstreamer-1.0/libgstrswebp.so | grep -F 'Shared library: [libwebpdemux.so'
    runHook postInstallCheck
  '';

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    updateScript = nix-update-script {
      # use numbered releases rather than gstreamer-* releases
      # this matches upstream's recommendation: https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/issues/470#note_2202772
      extraArgs = [
        "--version-regex"
        "([0-9.]+)"
      ];
    };
  };

  meta = {
    description = "GStreamer plugins written in Rust";
    mainProgram = "gst-webrtc-signalling-server";
    homepage = "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs";
    license = with lib.licenses; [
      mpl20
      asl20
      mit
      lgpl21Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tmarkus ];
    pkgConfigModules = pkgConfigNames;
  };
})
