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
  gstreamer,
  gst-plugins-base,
  gst-plugins-bad,
  gtk4,
  cairo,
  csound,
  dav1d,
  libsodium,
  libwebp,
  openssl,
  pango,
  gst-plugins-good,
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
  # populated from meson_options.txt (manually for now, but that might change in the future)
  validPlugins = {
    # audio
    audiofx = [ ];
    claxon = [ ];
    csound = [ csound ];
    lewton = [ ];
    spotify = [ ];

    # generic
    file = [ ];
    sodium = [ libsodium ];
    threadshare = [ ];

    # mux
    flavors = [ ];
    fmp4 = [ ];
    mp4 = [ ];

    # net
    aws = [ openssl ];
    hlssink3 = [ ];
    ndi = [ ];
    onvif = [ pango ];
    raptorq = [ ];
    reqwest = [ openssl ];
    rtp = [ ];
    webrtc = [
      gst-plugins-bad
      openssl
    ];
    webrtchttp = [
      gst-plugins-bad
      openssl
    ];

    # text
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
    videofx = [ cairo ];
    webp = [ libwebp ];
  };

  selectedPlugins =
    if plugins != null then
      lib.unique (lib.sort lib.lessThan plugins)
    else
      lib.subtractLists (
        [
          "csound" # tests have weird failure on x86, does not currently work on arm or darwin
          "livesync" # tests have suspicious intermittent failure, see https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/issues/357
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

  invalidPlugins = lib.subtractLists (lib.attrNames validPlugins) selectedPlugins;
in
assert lib.assertMsg (invalidPlugins == [ ])
  "Invalid gst-plugins-rs plugin${
    lib.optionalString (lib.length invalidPlugins > 1) "s"
  }: ${lib.concatStringsSep ", " invalidPlugins}";

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-plugins-rs";
  version = "0.14.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "gstreamer";
    repo = "gst-plugins-rs";
    rev = finalAttrs.version;
    hash = "sha256-mIq8Fo6KoxAo1cL2NQHnSMPgzUWl1eNJUujdaerGjFA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "gst-plugins-rs-${finalAttrs.version}";
    hash = "sha256-Z1mqpVL2SES1v0flykOwoDX2/apZHxg7eI5If4BsP4o=";
  };

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
    nasm
  ]
  # aws-lc-rs has no pregenerated bindings for exotic platforms
  # https://aws.github.io/aws-lc-rs/platform_support.html
  ++ lib.optionals (!(stdenv.hostPlatform.isx86 || stdenv.hostPlatform.isAarch64)) [
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_gstreamer
  ]
  ++ lib.concatMap (plugin: lib.getAttr plugin validPlugins) selectedPlugins;

  checkInputs = [
    gst-plugins-good
    gst-plugins-bad
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
  preConfigure = ''
    export CARGO_BUILD_JOBS=$NIX_BUILD_CORES

    patchShebangs dependencies.py
  ''
  + lib.optionalString (lib.elem "csound" selectedPlugins) ''
    export CSOUND_LIB_DIR=${lib.getLib csound}/lib
  '';

  mesonCheckFlags = [ "--verbose" ];

  preCheck = ''
    # Fontconfig error: No writable cache directories
    export XDG_CACHE_HOME=$(mktemp -d)
  '';

  postInstall = ''
    install -Dm444 -t ''${!outputDev}/lib/pkgconfig gst*.pc
  '';

  doInstallCheck =
    (lib.elem "webp" selectedPlugins) && !stdenv.hostPlatform.isStatic && stdenv.hostPlatform.isElf;
  installCheckPhase = ''
    runHook preInstallCheck
    readelf -a $out/lib/gstreamer-1.0/libgstrswebp.so | grep -F 'Shared library: [libwebpdemux.so'
    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script {
      # use numbered releases rather than gstreamer-* releases
      # this matches upstream's recommendation: https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/issues/470#note_2202772
      extraArgs = [
        "--version-regex"
        "([0-9.]+)"
      ];
    };
  };

  meta = with lib; {
    description = "GStreamer plugins written in Rust";
    mainProgram = "gst-webrtc-signalling-server";
    homepage = "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs";
    license = with licenses; [
      mpl20
      asl20
      mit
      lgpl21Plus
    ];
    platforms = platforms.unix;
    maintainers = [ ];
  };
})
