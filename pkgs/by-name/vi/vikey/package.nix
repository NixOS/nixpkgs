{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  fontconfig,
  gst_all_1,
  gtk4,
  ibus,
  libadwaita,
  libnotify,
  libx11,
  ninja,
  nix-update-script,
  pkg-config,
  python3,
  wrapGAppsHook4,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vikey";
  version = "1.0.31";

  src = fetchFromGitHub {
    owner = "tonyminibot";
    repo = "Vikey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+LkfC6vjLxmFV7mx1duuiGpWk9by4DT3bPECLvFw/UE=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # The daily check only points at the .deb/.rpm downloads on vikey.app, so turn it off by default.
  # Checking manually from the menu and enabling the switch in the settings both keep working.
  postPatch = ''
    substituteInPlace Linux/ibus/Engine.cpp \
      --replace-fail 'prefs::getInt("AutoUpdate", 1)' 'prefs::getInt("AutoUpdate", 0)'
    substituteInPlace Linux/settings/Settings.cpp \
      --replace-fail '"AutoUpdate", 1)' '"AutoUpdate", 0)'
  '';

  # Not `sourceRoot`: the build reads the whole tree and writes the test tools next to their sources.
  cmakeDir = "../Linux";

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    fontconfig
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk4
    ibus
    libadwaita
    libx11
  ];

  nativeCheckInputs = [ python3 ];

  doCheck = true;

  # The deterministic part of Linux/check.sh, without its performance budgets.
  checkPhase = ''
    runHook preCheck

    pushd ../Tools/autoswitch
    export PYTHONUTF8=1
    python3 rules/run_rules.py
    python3 rules/golden.py check
    driver/undo_test
    popd

    runHook postCheck
  '';

  # The engine and the settings app run these by name: vikey-settings, curl, notify-send and xdg-open.
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          (placeholder "out")
          curl
          libnotify
          xdg-utils
        ]
      }
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vietnamese Telex input method for IBus with automatic language switching";
    homepage = "https://vikey.app";
    changelog = "https://github.com/tonyminibot/Vikey/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "vikey-settings";
    maintainers = with lib.maintainers; [ imcvampire ];
    platforms = lib.platforms.linux;
    isIbusEngine = true;
  };
})
