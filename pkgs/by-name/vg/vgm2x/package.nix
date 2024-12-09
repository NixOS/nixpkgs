{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  libarchive,
  libzip,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vgm2x";
  version = "0-unstable-2024-11-17";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "vgm2x";
    rev = "615f68c160b035651d1a5111539d3d5ee0bd66a3";
    fetchSubmodules = true;
    hash = "sha256-coPpxMF83c7WXy0BGkBMOwRA2SPQho5O8vtKcXB5Vk4=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'pkg-config' "$PKG_CONFIG"
  '';

  strictDeps = true;

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libarchive
    libzip
  ];

  buildFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 vgm2x $out/bin/vgm2x

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "VGM file extraction tools";
    homepage = "https://github.com/vampirefrog/vgm2x";
    license = lib.licenses.gpl3Only;
    mainProgram = "vgm2x";
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
})
