{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  avahi,
  bluez,
  gettext,
  glib,
  gtest,
  gtk-layer-shell,
  gtk3,
  libnotify,
  nlohmann_json,
  openssl,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tether";
  version = "0.2.18";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zackb";
    repo = "tether";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ygevoa/gEt80HyRYeWmVGDIwi4Eyl8XVz/RABcGK03Q=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '"''${PROJECT_VERSION}-unknown"' '"${finalAttrs.version}"'
  '';

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    avahi
    glib
    gtk-layer-shell
    gtk3
    libnotify
    openssl
    wayland
  ];

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${gtest.src}")
    (lib.cmakeFeature "CHROME_MESSAGING_DIR" "etc/chromium/native-messaging-hosts")
    (lib.cmakeFeature "GOOGLE_CHROME_MESSAGING_DIR" "etc/opt/chrome/native-messaging-hosts")
    (lib.cmakeFeature "BLUETOOTHD_PATH" "${bluez}/libexec/bluetooth/bluetoothd")
    (lib.cmakeBool "TETHER_BUILD_EXTENSIONS" false)
  ];

  doCheck = true;
  enableParallelChecking = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux + iPhone Continuity / iMessage / SMS";
    homepage = "https://github.com/zackb/tether";
    changelog = "https://github.com/zackb/tether/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "tether";
    platforms = lib.platforms.linux;
  };
})
