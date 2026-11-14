{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  tt-smi,
  dbus,
  fontconfig,
  freetype,
  libGL,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  vulkan-loader,
  wayland,
  withTui ? true,
  withGui ? false,
  withEgui ? false,
  withApp ? false,
}:

let
  # tt-toplike-app hosts tt-toplike-tui in a PTY, so enabling the app must
  # also build and install the TUI binary.
  enableTui = withTui || withApp;
  hasGraphicalFrontend = withGui || withEgui || withApp;

  frontendFeatures =
    lib.optional enableTui "tui"
    ++ lib.optional withGui "gui"
    ++ lib.optional withEgui "egui"
    ++ lib.optional withApp "app";

  frontendBinaries =
    lib.optional enableTui "tt-toplike-tui"
    ++ lib.optional withGui "tt-toplike-gui"
    ++ lib.optional withEgui "tt-toplike-egui"
    ++ lib.optional withApp "tt-toplike-app";

  guiLibraries = [
    dbus
    fontconfig
    freetype
    libGL
    libx11
    libxcb
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    vulkan-loader
    wayland
  ];

  wrapperArgs = lib.escapeShellArgs (
    [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [ tt-smi ])
    ]
    ++ lib.optionals hasGraphicalFrontend [
      "--prefix"
      "LD_LIBRARY_PATH"
      ":"
      (lib.makeLibraryPath guiLibraries)
    ]
  );
in

assert lib.assertMsg (frontendBinaries != [ ]) "tt-toplike: at least one frontend must be enabled";

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tt-toplike";
  version = "0.6.2-unstable-2026-06-08";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-toplike";
    rev = "487bfe5aa6236068f6a7a148529601c57a2f7648";
    hash = "sha256-ZffI1RORPRbntYTeb8DgtpQcUMxrrYEhqzg5XPH2f+E=";
  };

  cargoHash = "sha256-puHjLwKCPFQBKGnMStzdnFxmDiALdkgJWld2W3Sd7Sc=";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = lib.optionals hasGraphicalFrontend guiLibraries;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "json-backend"
    "linux-procfs"
  ]
  ++ frontendFeatures;

  cargoBuildFlags = lib.concatMap (binary: [
    "--bin"
    binary
  ]) frontendBinaries;

  cargoTestFlags = [ "--lib" ];

  postFixup = ''
    for binary in ${lib.concatStringsSep " " frontendBinaries}; do
      if [ -x "$out/bin/$binary" ]; then
        wrapProgram "$out/bin/$binary" ${wrapperArgs}
      fi
    done
  '';

  passthru = {
    inherit
      withTui
      withGui
      withEgui
      withApp
      ;
  };

  meta = {
    description = "Real-time hardware monitoring for Tenstorrent silicon";
    homepage = "https://github.com/tenstorrent/tt-toplike";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers."mert-kurttutan" ];
    mainProgram = builtins.head frontendBinaries;
    platforms = [ "x86_64-linux" ];
  };
})
