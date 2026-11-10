{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unitree-sdk2";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "unitreerobotics";
    repo = "unitree_sdk2";
    rev = finalAttrs.version;
    hash = "sha256-a+O3jQDJFq/v0zhpGJVuwjgWAZWkIqiNfKt/L4IOSco=";
  };

  nativeBuildInputs = [
    cmake
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
  ];

  # The SDK core is a prebuilt static library; only cmake configure and install are needed
  dontBuild = true;

  meta = {
    description = "Unitree robot SDK version 2 for Go2, B2, H1, and G1 robots";
    homepage = "https://github.com/unitreerobotics/unitree_sdk2";
    license = lib.licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
