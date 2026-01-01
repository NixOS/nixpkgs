{
  abseil-cpp,
  cmake,
  cmark-gfm,
<<<<<<< HEAD
  coreutils,
  fetchFromGitHub,
  fetchNpmDeps,
  glaze,
=======
  fetchFromGitHub,
  fetchNpmDeps,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  kdePackages,
  lib,
  libqalculate,
  minizip,
  ninja,
  nodejs,
  npmHooks,
  pkg-config,
  protobuf,
  qt6,
<<<<<<< HEAD
  gcc15Stdenv,
  wayland,
  libxml2,
}:
gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "vicinae";
  version = "0.17.3";
=======
  rapidfuzz-cpp,
  stdenv,
  wayland,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vicinae";
  version = "0.16.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "vicinaehq";
    repo = "vicinae";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-EzvASqrcGZqWyESuYNKRnH17s5hBJK2woIrS6iD6nOs=";
=======
    hash = "sha256-4t0AscBe+TMhQ5SuzkBSgKrMXGs/2BvlRv8ke3pg+yo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  apiDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/typescript/api";
<<<<<<< HEAD
    hash = "sha256-UsTpMR23UQBRseRo33nbT6z/UCjZByryWfn2AQSgm6U=";
=======
    hash = "sha256-4OgVCnw5th2TcXszVY5G9ENr3/Y/eR2Kd45DbUhQRNk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  extensionManagerDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/typescript/extension-manager";
<<<<<<< HEAD
    hash = "sha256-wl8FDFB6Vl1zD0/s2EbU6l1KX4rwUW6dOZof4ebMMO8=";
=======
    hash = "sha256-krDFHTG8irgVk4a79LMz148drLgy2oxEoHCKRpur1R4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cmakeFlags = lib.mapAttrsToList lib.cmakeFeature {
    "VICINAE_GIT_TAG" = "v${finalAttrs.version}";
    "VICINAE_PROVENANCE" = "nix";
    "INSTALL_NODE_MODULES" = "OFF";
<<<<<<< HEAD
    "USE_SYSTEM_GLAZE" = "ON";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    "CMAKE_INSTALL_PREFIX" = placeholder "out";
    "CMAKE_INSTALL_DATAROOTDIR" = "share";
    "CMAKE_INSTALL_BINDIR" = "bin";
    "CMAKE_INSTALL_LIBDIR" = "lib";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    nodejs
    pkg-config
    protobuf
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    abseil-cpp
    cmark-gfm
<<<<<<< HEAD
    glaze
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    kdePackages.layer-shell-qt
    kdePackages.qtkeychain
    libqalculate
    minizip
    nodejs
    protobuf
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
<<<<<<< HEAD
    wayland
    libxml2
=======
    rapidfuzz-cpp
    wayland
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  postPatch = ''
    local postPatchHooks=()
    source ${npmHooks.npmConfigHook}/nix-support/setup-hook
    npmRoot=typescript/api npmDeps=${finalAttrs.apiDeps} npmConfigHook
    npmRoot=typescript/extension-manager npmDeps=${finalAttrs.extensionManagerDeps} npmConfigHook
  '';

  qtWrapperArgs = [
    "--prefix PATH :  ${
      lib.makeBinPath [
        nodejs
        (placeholder "out")
      ]
    }"
  ];

<<<<<<< HEAD
  postFixup = ''
    substituteInPlace $out/share/systemd/user/vicinae.service \
      --replace-fail "/bin/kill" "${lib.getExe' coreutils "kill"}"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Native, fast, extensible launcher for the desktop";
=======
  passthru.updateScript = ./update.sh;

  meta = {
    description = "A focused launcher for your desktop — native, fast, extensible";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/vicinaehq/vicinae";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dawnofmidnight
      zstg
    ];
    platforms = lib.platforms.linux;
    mainProgram = "vicinae";
  };
})
