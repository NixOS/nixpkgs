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
<<<<<<< HEAD
  version = "1.4.335.0";
=======
  version = "1.4.328.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Utility-Libraries";
    rev = "vulkan-sdk-${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-lDO0B7wEYT6cc/t/ZW5OAxxgRfDORoGd+pF5r5R7yoQ=";
=======
    hash = "sha256-qcCATZWM0YJ02Dl5VxjvbFYoE2b0r7Ku+ELr2is2VIg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [ vulkan-headers ];

<<<<<<< HEAD
  meta = {
    description = "Set of utility libraries for Vulkan";
    homepage = "https://github.com/KhronosGroup/Vulkan-Utility-Libraries";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
=======
  meta = with lib; {
    description = "Set of utility libraries for Vulkan";
    homepage = "https://github.com/KhronosGroup/Vulkan-Utility-Libraries";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
