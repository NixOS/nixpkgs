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
  version = "1.0.0-unstable-2026-08-02";

  src = fetchFromGitHub {
    owner = "HarbourMasters";
    repo = "Torch";
    rev = "270279d4193d9a09b4525903f5f0471dd3d203fd";
    hash = "sha256-q12F92jxwY2AFm5iHppQbJhhyNtXLSZNXIjcf5vDf7Q=";
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
        rev = "79524ddd08a4ec981b7fea76afd08ee05f83755d";
        hash = "sha256-bL3hQmERXNwGmDoi7+wLv/TkppGhG6cO47k1iZvJGzY=";
      };
      yaml-cpp_src = fetchFromGitHub {
        owner = "jbeder";
        repo = "yaml-cpp";
        rev = "56e3bb550c91fd7005566f19c079cb7a503223cf"; # 0.9.0
        hash = "sha256-+FOsPQY44h1g9tEw3O281LkiYKXdW2jnFKw+oTRkhGw=";
      };
      tinyxml2_src = srcOnly tinyxml-2;
      zlib_src = fetchFromGitHub {
        owner = "madler";
        repo = "zlib";
        tag = "v1.3.1";
        hash = "sha256-TkPLWSN5QcPlL9D0kc/yhH0/puE9bFND24aj5NVDKYs=";
      };
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

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_ZLIB" true)
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
