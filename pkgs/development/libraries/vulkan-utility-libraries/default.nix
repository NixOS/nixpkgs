{ lib, stdenv, fetchFromGitHub, cmake, python3, vulkan-headers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-utility-libraries";
  version = "1.3.275.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Utility-Libraries";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-gvia+Xb9BpOjPARKo3Sgp85Bfh1roFZ2PzCtXVFYeIU=";
  };

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ vulkan-headers ];

  meta = with lib; {
    description = "A set of utility libraries for Vulkan";
    homepage = "https://github.com/KhronosGroup/Vulkan-Utility-Libraries";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
})
