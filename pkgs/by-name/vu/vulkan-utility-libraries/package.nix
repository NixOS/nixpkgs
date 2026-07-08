{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  vulkan-headers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-utility-libraries";
  version = "1.4.350.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Utility-Libraries";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-E0T5eSI30eDB7//6srjwlkX9HfUp1UiyCPWDyK+ZEi8=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [ vulkan-headers ];

  meta = {
    description = "Set of utility libraries for Vulkan";
    homepage = "https://github.com/KhronosGroup/Vulkan-Utility-Libraries";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
