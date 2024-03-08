{ lib
, stdenv
, fetchFromGitLab

, cmake

, glm
, libGL
, openxr-loader
, python3
, vulkan-headers
, vulkan-loader
, xorg

, nix-update-script
}:

stdenv.mkDerivation {
  pname = "opencomposite";
  version = "unstable-2024-02-16";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    rev = "737bbedd29343bc2f808804e2b24302390a07655";
    hash = "sha256-azb7T0d0YMQRc0Slq1tzNj6bOmCzfHW3ciY9lN+RTao=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    glm
    libGL
    openxr-loader
    python3
    vulkan-headers
    vulkan-loader
    xorg.libX11
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_OPENXR=ON"
    "-DUSE_SYSTEM_GLM=ON"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/opencomposite
    cp -r bin/ $out/lib/opencomposite
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=openxr" ];
  };

  meta = with lib; {
    description = "Reimplementation of OpenVR, translating calls to OpenXR";
    homepage = "https://gitlab.com/znixian/OpenOVR";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ Scrumplex ];
  };
}
