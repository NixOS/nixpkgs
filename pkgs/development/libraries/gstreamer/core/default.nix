{
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gettext,
  bison,
  flex,
  python3,
  glib,
  makeWrapper,
  libcap,
  elfutils, # for libdw
  bash-completion,
  lib,
  testers,
  rustc,
  withRust ?
    lib.any (lib.meta.platformMatch stdenv.hostPlatform) rustc.targetPlatforms
    && lib.all (p: !lib.meta.platformMatch stdenv.hostPlatform p) rustc.badTargetPlatforms,
  gobject-introspection,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  libunwind,
  withLibunwind ?
    lib.meta.availableOn stdenv.hostPlatform libunwind
    && lib.elem "libunwind" libunwind.meta.pkgConfigModules or [ ],
  # Checks meson.is_cross_build(), so even canExecute isn't enough.
  enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform,
  hotdoc,
  directoryListingUpdater,
  apple-sdk_gstreamer,
}:

let
  hasElfutils = lib.meta.availableOn stdenv.hostPlatform elfutils;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gstreamer";
  version = "1.26.5";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  separateDebugInfo = true;

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-${finalAttrs.version}.tar.xz";
    hash = "sha256-Cn7bDntC2+a1dfzmGkgIo/ayDghaHq7LwCXQ7CHx53Q=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    bison
    flex
    python3
    makeWrapper
    glib
    bash-completion
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap # for setcap binary
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ]
  ++ lib.optionals withRust [
    rustc
  ]
  ++ lib.optionals enableDocumentation [
    hotdoc
  ];

  buildInputs = [
    bash-completion
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
  ]
  ++ lib.optionals hasElfutils [
    elfutils
  ]
  ++ lib.optionals withLibunwind [
    libunwind
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_gstreamer
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dglib_debug=disabled" # cast checks should be disabled on stable releases
    "-Ddbghelp=disabled" # not needed as we already provide libunwind and libdw, and dbghelp is a fallback to those
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    (lib.mesonEnable "ptp-helper" withRust)
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonEnable "doc" enableDocumentation)
    (lib.mesonEnable "libunwind" withLibunwind)
    (lib.mesonEnable "libdw" (withLibunwind && hasElfutils))
  ];

  postPatch = ''
    patchShebangs \
      gst/parse/get_flex_version.py \
      gst/parse/gen_grammar.py.in \
      gst/parse/gen_lex.py.in \
      libs/gst/helpers/ptp_helper_post_install.sh \
      scripts/extract-release-date-from-doap-file.py \
      docs/gst-plugins-doc-cache-generator.py
  '';

  postInstall = ''
    for prog in "$bin/bin/"*; do
        # We can't use --suffix here due to quoting so we craft the export command by hand
        wrapProgram "$prog" --run 'export GST_PLUGIN_SYSTEM_PATH_1_0=$GST_PLUGIN_SYSTEM_PATH_1_0''${GST_PLUGIN_SYSTEM_PATH_1_0:+:}$(unset _tmp; for profile in $NIX_PROFILES; do _tmp="$profile/lib/gstreamer-1.0''${_tmp:+:}$_tmp"; done; printf '%s' "$_tmp")'
    done
  '';

  preFixup = ''
    moveToOutput "share/bash-completion" "$bin"
  '';

  setupHook = ./setup-hook.sh;

  passthru = {
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };
    updateScript = directoryListingUpdater { };
  };

  meta = with lib; {
    description = "Open source multimedia framework";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    pkgConfigModules = [
      "gstreamer-controller-1.0"
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [
      ttuegel
      matthewbauer
    ];
  };
})
