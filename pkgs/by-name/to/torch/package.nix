{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  tinyxml-2,
  srcOnly,
  cmake,
  installShellFiles,
  ninja,
  bzip2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "torch";
  version = "1.0.0-unstable-2025-07-09";

  src = fetchFromGitHub {
    owner = "HarbourMasters";
    repo = "Torch";
    rev = "e93d95457ebb337dfeced69ffd1f28dc0b9fbf02";
    hash = "sha256-hsfx68IHd91PLArmHJiKBZjCvkiVPiUiO8EMD4LNg1Q=";
  };

  patches = [
    # Can't fetch these torch deps in the sandbox
    (replaceVars ./git-deps.patch {
      libgfxd_src = fetchFromGitHub {
        owner = "glankk";
        repo = "libgfxd";
        rev = "96fd3b849f38b3a7c7b7f3ff03c5921d328e6cdf";
        hash = "sha256-dedZuV0BxU6goT+rPvrofYqTz9pTA/f6eQcsvpDWdvQ=";
      };
      spdlog_src = fetchFromGitHub {
        owner = "gabime";
        repo = "spdlog";
        rev = "7e635fca68d014934b4af8a1cf874f63989352b7";
        hash = "sha256-cxTaOuLXHRU8xMz9gluYz0a93O0ez2xOxbloyc1m1ns=";
      };
      yaml-cpp_src = fetchFromGitHub {
        owner = "jbeder";
        repo = "yaml-cpp";
        rev = "2f86d13775d119edbb69af52e5f566fd65c6953b";
        hash = "sha256-GtUTbEaRR3+GfVkt3t8EsqBHVffVKOl8urtQTaHozIo=";
      };
      tinyxml2_src = srcOnly tinyxml-2;
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    installShellFiles
    ninja
  ];

  buildInputs = [
    bzip2
    zlib
  ];

  installPhase = ''
    runHook preInstall

    installBin torch

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/HarbourMasters/Torch";
    description = "Generic asset processor for games";
    mainProgram = "torch";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ qubitnano ];
    license = with lib.licenses; [
      mit
      unfree # Reverse engineering
    ];
  };

})
