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
  version = "unstable-2023-09-11";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    rev = "cca18158a4b6921df54e84a3b23ff459f76a2bde";
    hash = "sha256-VREApt4juz283aJVLZoBbqg01PNs4XBxmpr/UIMlaK8=";
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
