{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cairo,
  meson,
  ninja,
  pkg-config,
  gstreamer,
  gst-plugins-base,
  gst-plugins-bad,
  gst-rtsp-server,
  python3,
  gobject-introspection,
  rustPlatform,
  rustc,
  cargo,
  json-glib,
  # Checks meson.is_cross_build(), so even canExecute isn't enough.
  enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform,
  hotdoc,
  directoryListingUpdater,
  _experimental-update-script-combinators,
  common-updater-scripts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-devtools";
  version = "1.26.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-${finalAttrs.version}.tar.xz";
    hash = "sha256-7/M9fcKSuwdKJ4jqiHtigzmP/e+vpJ+30I7+ZlimVkg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    name = "gst-devtools-${finalAttrs.version}";
    hash = "sha256-p26jeKRDSPTgQzf4ckhLPSFa8RKsgkjUEXJG8IlPPZo=";
  };

  patches = [
    # Fix Requires in gstreamer-validate-1.0.pc
    # https://gitlab.freedesktop.org/gstreamer/gstreamer/-/merge_requests/8661
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/gstreamer/gstreamer/-/commit/8c002efa867ae7fc566f9f977a15e338a488de50.patch";
      stripLen = 3;
      extraPrefix = "";
      hash = "sha256-JH5rs9LT1YYOnOS1B1mbci9UFg/LfPyKmQ1J4LwQj7Q=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ] ++ lib.optionals enableDocumentation [
    hotdoc
  ];

  buildInputs = [
    cairo
    python3
    json-glib
  ];

  propagatedBuildInputs = [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gst-rtsp-server
  ];

  mesonFlags = [
    (lib.mesonEnable "doc" enableDocumentation)
  ];

  cargoRoot = "dots-viewer";

  passthru = {
    updateScript =
      let
        updateSource = directoryListingUpdater { };

        updateLockfile = {
          command = [
            "sh"
            "-c"
            ''
              PATH=${
                lib.makeBinPath [
                  common-updater-scripts
                ]
              }
              update-source-version gst_all_1.gst-devtools --ignore-same-version --source-key=cargoDeps.vendorStaging > /dev/null
            ''
          ];
          # Experimental feature: do not copy!
          supportedFeatures = [ "silent" ];
        };
      in
      _experimental-update-script-combinators.sequence [
        updateSource
        updateLockfile
      ];
  };

  meta = with lib; {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
})
