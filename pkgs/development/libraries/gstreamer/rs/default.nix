{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchFromGitHub,
  fetchpatch,
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
  Security,
  SystemConfiguration,
  gst-plugins-good,
  nix-update-script,
  # specifies a limited subset of plugins to build (the default `null` means all plugins supported on the stdenv platform)
  plugins ? null,
  withGtkPlugins ? true,
  # Checks meson.is_cross_build(), so even canExecute isn't enough.
  enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform && plugins == null,
  hotdoc,
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
    aws = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];
    hlssink3 = [ ];
    ndi = [ ];
    onvif = [ pango ];
    raptorq = [ ];
    reqwest = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];
    rtp = [ ];
    webrtc =
      [
        gst-plugins-bad
        openssl
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        Security
        SystemConfiguration
      ];
    webrtchttp =
      [
        gst-plugins-bad
        openssl
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        Security
        SystemConfiguration
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

  # TODO: figure out what must be done about this upstream - related lu-zero/cargo-c#323 lu-zero/cargo-c#138
  cargo-c' = (cargo-c.__spliced.buildHost or cargo-c).overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      (fetchpatch {
        name = "cargo-c-test-rlib-fix.patch";
        url = "https://github.com/lu-zero/cargo-c/commit/8421f2da07cd066d2ae8afbb027760f76dc9ee6c.diff";
        hash = "sha256-eZSR4DKSbS5HPpb9Kw8mM2ZWg7Y92gZQcaXUEu1WNj0=";
        revert = true;
      })
    ];
  });
in
assert lib.assertMsg (invalidPlugins == [ ])
  "Invalid gst-plugins-rs plugin${
    lib.optionalString (lib.length invalidPlugins > 1) "s"
  }: ${lib.concatStringsSep ", " invalidPlugins}";

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-plugins-rs";
  version = "0.13.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "gstreamer";
    repo = "gst-plugins-rs";
    rev = finalAttrs.version;
    hash = "sha256-G6JdZXBNiZfbu6EBTOsJ4Id+BvPhIToZmHHi7zuapnE=";
    # TODO: temporary workaround for case-insensitivity problems with color-name crate - https://github.com/annymosse/color-name/pull/2
    postFetch = ''
      sedSearch="$(cat <<\EOF | sed -ze 's/\n/\\n/g'
      \[\[package\]\]
      name = "color-name"
      version = "\([^"\n]*\)"
      source = "registry+https://github.com/rust-lang/crates.io-index"
      checksum = "[^"\n]*"
      EOF
      )"
      sedReplace="$(cat <<\EOF | sed -ze 's/\n/\\n/g'
      [[package]]
      name = "color-name"
      version = "\1"
      source = "git+https://github.com/lilyinstarlight/color-name#cac0ed5b7d2e0682c08c9bfd13089d5494e81b9a"
      EOF
      )"
      sed -i -ze "s|$sedSearch|$sedReplace|g" $out/Cargo.lock
    '';
  };

  cargoDeps =
    with finalAttrs;
    rustPlatform.fetchCargoVendor {
      inherit src;
      name = "${pname}-${version}";
      hash = "sha256-NFB9kNmCF3SnOgpSd7SSihma+Ooqwxtrym9Il4A+uQY=";
    };

  strictDeps = true;

  nativeBuildInputs =
    [
      rustPlatform.cargoSetupHook
      meson
      ninja
      python3
      python3.pkgs.tomli
      pkg-config
      rustc
      cargo
      cargo-c'
      nasm
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
  ] ++ lib.concatMap (plugin: lib.getAttr plugin validPlugins) selectedPlugins;

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
  preConfigure =
    ''
      export CARGO_BUILD_JOBS=$NIX_BUILD_CORES

      patchShebangs dependencies.py
    ''
    + lib.optionalString (lib.elem "csound" selectedPlugins) ''
      export CSOUND_LIB_DIR=${lib.getLib csound}/lib
    '';

  mesonCheckFlags = [ "--verbose" ];

  doInstallCheck =
    (lib.elem "webp" selectedPlugins) && !stdenv.hostPlatform.isStatic && stdenv.hostPlatform.isElf;
  installCheckPhase = ''
    runHook preInstallCheck
    readelf -a $out/lib/gstreamer-1.0/libgstrswebp.so | grep -F 'Shared library: [libwebpdemux.so'
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script {
    # use numbered releases rather than gstreamer-* releases
    # this matches upstream's recommendation: https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/issues/470#note_2202772
    extraArgs = [
      "--version-regex"
      "([0-9.]+)"
    ];
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
