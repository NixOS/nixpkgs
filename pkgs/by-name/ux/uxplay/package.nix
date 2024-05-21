{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  libplist,
  pkg-config,
  wrapGAppsHook3,
  avahi,
  avahi-compat,
  gst_all_1,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uxplay";
  version = "1.68.3";

  src = fetchFromGitHub {
    owner = "FDH2";
    repo = "UxPlay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ev+VXI37zLRQ3yqllJVo1JZK/U82HeB65Hi9+c0O8Ks=";
  };

  postPatch = ''
    substituteInPlace lib/CMakeLists.txt \
      --replace ".a" "${stdenv.hostPlatform.extensions.sharedLibrary}"
    sed -i '/PKG_CONFIG_EXECUTABLE/d' renderers/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    openssl
    libplist
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    avahi
    avahi-compat
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
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
