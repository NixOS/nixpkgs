{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  yaml-cpp,
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
  version = "1.0.0-unstable-2026-05-27";

  src = fetchFromGitHub {
    owner = "HarbourMasters";
    repo = "Torch";
    rev = "d5799b579b3eb24b9c2a5046c862dd6ffd9bc096";
    hash = "sha256-XEAfc+E1uMxFKiqt0ZCrbKZNlqCbG5BmvVvEDQoC+C4=";
  };

  patches = [
    # Can't fetch these deps in the sandbox
    # torch fails to build without some specific versions
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
      yaml-cpp_src = srcOnly yaml-cpp;
      tinyxml2_src = srcOnly tinyxml-2;
    })
  ];

  strictDeps = true;
  __structuredAttrs = true;

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
