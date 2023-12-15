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
}:

stdenv.mkDerivation {
  pname = "opencomposite";
  version = "unstable-2023-12-28";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    rev = "2ab29e49c96c5e446e439a408521a677737c4956";
    hash = "sha256-he8ceYe6Q9DeaBkjvOihcd7DP6hCR0XVeRl7ySonUXk=";
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

  meta = with lib; {
    description = "Reimplementation of OpenVR, translating calls to OpenXR";
    homepage = "https://gitlab.com/znixian/OpenOVR";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ Scrumplex ];
  };
}
