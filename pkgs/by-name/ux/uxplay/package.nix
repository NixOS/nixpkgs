{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  avahi,
  avahi-compat,
  gst_all_1,
  libplist,
  openssl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uxplay";
  version = "1.71.1";

  src = fetchFromGitHub {
    owner = "FDH2";
    repo = "UxPlay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qb/oYTScbHypwyo+znhDw8Mz5u+uhM8Jn6Gff3JK+Bc=";
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
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
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
