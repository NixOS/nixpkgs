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
  apple-sdk_gstreamer,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-devtools";
  version = "1.26.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-${finalAttrs.version}.tar.xz";
    hash = "sha256-Y9Rqjv+ooiXiWkZLp1OKzoU/4NwecDZrJ8IIE15UAc4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      src
      patches
      cargoRoot
      ;
    name = "gst-devtools-${finalAttrs.version}";
    hash = "sha256-gU+SBvxwmrGiyeKXF3SA2ohIHNTS4ZBC+elB0u1QKRE=";
  };

  patches = [
    # dots-viewer: sort static files
    # https://gitlab.freedesktop.org/gstreamer/gstreamer/-/merge_requests/9208
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/gstreamer/gstreamer/-/commit/b3099f78775eab1ac19a9e163c0386e01e74b768.patch";
      stripLen = 2;
      hash = "sha256-QRHqbZ6slYcwGl+o9Oi4jV+ANMorCED4cQV5qDS74eg=";
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
  ]
  ++ lib.optionals enableDocumentation [
    hotdoc
  ];

  buildInputs = [
    cairo
    python3
    json-glib
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    apple-sdk_gstreamer
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
