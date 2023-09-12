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
  version = "unstable-2023-07-02";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    rev = "a59b16204a1ee61a59413667a516375071a113f0";
    hash = "sha256-JSVd/+A/WldP+A2vOOG4lbwb4QCE/PymEm4VbjUxWrw=";
  };

  patches = [
    # Force OpenComposite to use our OpenXR and glm, instead of its Git submodules
    ./cmake-use-find_package-where-needed.patch
  ];

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
