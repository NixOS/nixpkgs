{ lib
, stdenv
, fetchFromGitLab
, fetchFromGitHub
, fetchpatch
, rustPlatform
, meson
, ninja
, python3
, pkg-config
, rustc
, cargo
, cargo-c
, lld
, nasm
, gstreamer
, gst-plugins-base
, gst-plugins-bad
, gtk4
, cairo
, csound
, dav1d
, libsodium
, libwebp
, openssl
, pango
, Security
, SystemConfiguration
, gst-plugins-good
, nix-update-script
# specifies a limited subset of plugins to build (the default `null` means all plugins supported on the stdenv platform)
, plugins ? null
, withGtkPlugins ? true
# Checks meson.is_cross_build(), so even canExecute isn't enough.
, enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform && plugins == null
, hotdoc
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
    aws = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];
    hlssink3 = [ ];
    ndi = [ ];
    onvif = [ pango ];
    raptorq = [ ];
    reqwest = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];
    rtp = [ ];
    webrtc = [ gst-plugins-bad openssl ] ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];
    webrtchttp = [ gst-plugins-bad openssl ] ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

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
    dav1d = [
      # Only dav1d < 1.3 is supported for now.
      # https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/merge_requests/1393
      (dav1d.overrideAttrs rec {
        version = "1.2.1";
        src = fetchFromGitHub {
          owner = "videolan";
          repo = "dav1d";
          rev = version;
          hash = "sha256-RrEim3HXXjx2RUU7K3wPH3QbhNTRN9ZX/oAcyE9aV8I=";
        };
      })
    ];
    ffv1 = [ ];
    gif = [ ];
    gtk4 = [ gtk4 ];
    hsv = [ ];
    png = [ ];
    rav1e = [ ];
    videofx = [ cairo ];
    webp = [ libwebp ];
  };

  selectedPlugins = if plugins != null then lib.unique (lib.sort lib.lessThan plugins) else lib.subtractLists (
    [
      "csound" # tests have weird failure on x86, does not currently work on arm or darwin
      "livesync" # tests have suspicious intermittent failure, see https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/issues/357
    ] ++ lib.optionals stdenv.isAarch64 [
      "raptorq" # pointer alignment failure in tests on aarch64
    ] ++ lib.optionals stdenv.isDarwin [
      "reqwest" # tests hang on darwin
      "threadshare" # tests cannot bind to localhost on darwin
      "webp" # not supported on darwin (upstream crate issue)
    ] ++ lib.optionals (!gst-plugins-base.glEnabled || !withGtkPlugins) [
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
    patches = (oldAttrs.patches or []) ++ [
      (fetchpatch {
        name = "cargo-c-test-rlib-fix.patch";
        url = "https://github.com/lu-zero/cargo-c/commit/8421f2da07cd066d2ae8afbb027760f76dc9ee6c.diff";
        hash = "sha256-eZSR4DKSbS5HPpb9Kw8mM2ZWg7Y92gZQcaXUEu1WNj0=";
        revert = true;
      })
    ];
  });
in
  assert lib.assertMsg (invalidPlugins == [])
    "Invalid gst-plugins-rs plugin${lib.optionalString (lib.length invalidPlugins > 1) "s"}: ${lib.concatStringsSep ", " invalidPlugins}";

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-plugins-rs";
  version = "0.12.8";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "gstreamer";
    repo = "gst-plugins-rs";
    rev = finalAttrs.version;
    hash = "sha256-AGXKI/0Y2BdaSnpQAt3T/rkYlM8UpQpKm4kMAGd6Dyk=";
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

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cairo-rs-0.19.8" = "sha256-AdIUcxxuZVAWQ+KOBTrtsvTu4KtFiXkQPYWT9Avt7Z0=";
      "color-name-1.1.0" = "sha256-RfMStbe2wX5qjPARHIFHlSDKjzx8DwJ+RjzyltM5K7A=";
      "ffv1-0.0.0" = "sha256-af2VD00tMf/hkfvrtGrHTjVJqbl+VVpLaR0Ry+2niJE=";
      "flavors-0.2.0" = "sha256-zBa0X75lXnASDBam9Kk6w7K7xuH9fP6rmjWZBUB5hxk=";
      "gdk4-0.8.2" = "sha256-DZjHlhzrELZ8M5YUM5kSeOphjF7863DmywFgGbZL4Jo=";
      "gstreamer-0.22.7" = "sha256-vTEDqmyqhj9e7r7N0QfG4uTNBizrU0gTUfLOJ8kU1JE=";
    };
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
    cargo-c'
    nasm
  ] ++ lib.optionals stdenv.isDarwin [
    lld
  ] ++ lib.optionals enableDocumentation [
    hotdoc
  ];

  env = lib.optionalAttrs stdenv.isDarwin { NIX_CFLAGS_LINK = "-fuse-ld=lld"; };

  buildInputs = [
    gstreamer
    gst-plugins-base
  ] ++ lib.concatMap (plugin: lib.getAttr plugin validPlugins) selectedPlugins;

  checkInputs = [
    gst-plugins-good
    gst-plugins-bad
  ];

  mesonFlags = (
    map (plugin: lib.mesonEnable plugin true) selectedPlugins
  ) ++ [
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
  '' + lib.optionalString (lib.elem "csound" selectedPlugins) ''
    export CSOUND_LIB_DIR=${lib.getLib csound}/lib
  '';

  # give meson longer before timing out for tests
  mesonCheckFlags = [ "--verbose" "--timeout-multiplier" "12" ];

  doInstallCheck = (lib.elem "webp" selectedPlugins) && !stdenv.hostPlatform.isStatic &&
    stdenv.hostPlatform.isElf;
  installCheckPhase = ''
    runHook preInstallCheck
    readelf -a $out/lib/gstreamer-1.0/libgstrswebp.so | grep -F 'Shared library: [libwebpdemux.so'
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script {
    # use numbered releases rather than gstreamer-* releases
    # this matches upstream's recommendation: https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/issues/470#note_2202772
    extraArgs = [ "--version-regex" "([0-9.]+)" ];
  };

  meta = with lib; {
    description = "GStreamer plugins written in Rust";
    mainProgram = "gst-webrtc-signalling-server";
    homepage = "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs";
    license = with licenses; [ mpl20 asl20 mit lgpl21Plus ];
    platforms = platforms.unix;
    maintainers = [ ];
  };
})
