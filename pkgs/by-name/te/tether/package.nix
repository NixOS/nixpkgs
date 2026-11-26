{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  avahi,
  ffmpeg,
  gettext,
  glib,
  gtest,
  gtk-layer-shell,
  gtk3,
  libnotify,
  libsecret,
  ncurses,
  nlohmann_json,
  openssl,
  pipewire,
  procps,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tether";
  version = "0.3.6";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zackb";
    repo = "tether";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vdAjOi9e4L7M5RfYDuyl5ipbiEK+NU0MR30khCOucLo=";
  };

  postPatch = ''
    substituteInPlace packaging/systemd/tetherd.service.in \
      --replace-fail /usr/bin/pkill ${lib.getExe' procps "pkill"}
  '';

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    avahi
    ffmpeg
    glib
    gtk-layer-shell
    gtk3
    libnotify
    libsecret
    ncurses
    openssl
    pipewire
    wayland
  ];

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_NLOHMANN_JSON" "${nlohmann_json.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${gtest.src}")
    (lib.cmakeFeature "TETHER_VERSION" finalAttrs.version)
    (lib.cmakeFeature "CHROME_MESSAGING_DIR" "etc/chromium/native-messaging-hosts")
    (lib.cmakeFeature "GOOGLE_CHROME_MESSAGING_DIR" "etc/opt/chrome/native-messaging-hosts")
    (lib.cmakeBool "TETHER_BUILD_EXTENSIONS" false)
  ];

  doCheck = true;

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
