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
  version = "0-unstable-2024-12-13";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "vgm2x";
    rev = "ae37e3a8a2d563733c89e00597a18b5deac80b4f";
    fetchSubmodules = true;
    hash = "sha256-wRwfRlABy5Ojyjohs68Uqvq0otMbvBCexLpGPmx6sds=";
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
