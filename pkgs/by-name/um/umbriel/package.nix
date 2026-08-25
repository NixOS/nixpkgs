{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wayland,
  wayland-protocols,
  wlroots_0_20,
  libxkbcommon,
  libinput,
  pixman,
  cairo,
  pango,
  libGL,
  libdrm,
  libgbm,
  libxcb,
  libxcb-wm,
  lcms2,
  jemalloc,
  tomlplusplus,
  nlohmann_json,
  xwayland-satellite,
  makeBinaryWrapper,
  versionCheckHook,
  unstableGitUpdater,
}:
stdenv.mkDerivation {
  pname = "umbriel";
  version = "0-unstable-2026-08-25";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "umbriel";
    # No tagged releases yet
    rev = "af351dfa7564eaa0e73d215d057eb0b209cba057";
    fetchSubmodules = true;
    hash = "sha256-y/ofPV9De3qxrLsmmAUs4fX/ZaNBquqvm6VvnnNXXhA=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    wayland-scanner
    wlroots_0_20
    libxkbcommon
    libinput
    pixman
    tomlplusplus
    libGL
    nlohmann_json
    libdrm
    libgbm
    libxcb
    libxcb-wm
    lcms2
    jemalloc
    cairo
    pango
  ];

  mesonBuildType = "release";

  mesonInstallFlags = [ "--skip-subprojects" ];

  postInstall = ''
    if [ -f "$out/share/wayland-sessions/umbriel.desktop" ]; then
      substituteInPlace "$out/share/wayland-sessions/umbriel.desktop" \
        --replace-fail 'Exec=start-umbriel' "Exec=$out/bin/start-umbriel"
    fi
    wrapProgram $out/bin/umbriel \
      --prefix PATH : ${lib.makeBinPath [ xwayland-satellite ]}
  '';

  doCheck = true;

  # Set up to version check below, but currently it's untagged so the version doesn't match.
  # On first release, set this to true make the version check run.
  doInstallCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  passthru = {
    providedSessions = [ "umbriel" ];
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Wayland compositor built on wlroots and SceneFX";
    homepage = "https://docs.noctalia.dev/umbriel/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "umbriel";
    maintainers = with lib.maintainers; [
      pyrox0
      samiser
    ];
  };
}
