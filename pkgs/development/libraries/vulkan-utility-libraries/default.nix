{ lib, stdenv, fetchFromGitHub, cmake, python3, vulkan-headers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-utility-libraries";
  version = "1.3.268";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Utility-Libraries";
    rev = "v${finalAttrs.version}";
    hash = "sha256-l6PiHCre/JQg8PSs1k/0Zzfwwv55AqVdZtBbjeKLS6E=";
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
