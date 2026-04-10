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
  version = "1.4.363.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Utility-Libraries";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-80+TpPaAbOKg/PrIfc+uYpj1mJ9VLiMXpWnEYjiw048=";
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
