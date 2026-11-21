{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  avahi,
  avahi-compat,
  gstreamer,
  gst-plugins-ugly,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  gst-libav,
  libplist,
  openssl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uxplay";
  version = "1.73.7";

  src = fetchFromGitHub {
    owner = "FDH2";
    repo = "UxPlay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-S4E2PB8Wgtv5BZ/WVHE0wm1kuhqpyXsV48MI20prZ+I=";
  };

  postPatch = ''
    substituteInPlace lib/CMakeLists.txt \
      --replace "APPLE" "FALSE" \
      --replace ".a" "${stdenv.hostPlatform.extensions.sharedLibrary}"
    sed -i -e '/PKG_CONFIG_EXECUTABLE/d' -e '/PKG_CONFIG_PATH/d' renderers/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    avahi
    avahi-compat
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
    libplist
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/FDH2/UxPlay/releases/tag/v${finalAttrs.version}";
    description = "AirPlay Unix mirroring server";
    homepage = "https://github.com/FDH2/UxPlay";
    license = lib.licenses.gpl3Plus;
    mainProgram = "uxplay";
    maintainers = [ lib.maintainers.azuwis ];
    platforms = lib.platforms.unix;
  };
})
