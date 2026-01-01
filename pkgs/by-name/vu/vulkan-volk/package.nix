{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "volk";
<<<<<<< HEAD
  version = "1.4.335.0";
=======
  version = "1.4.328.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "volk";
    rev = "vulkan-sdk-${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-qAMMhaeJweHNeW7+5RUpFh65jUnuw0TsYwq3PrKvCkM=";
=======
    hash = "sha256-7JhTLhCqdn/zDIYdIb2xJnjJVk57i+6M5OXk0KvfpDk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ vulkan-headers ];

  cmakeFlags = [ "-DVOLK_INSTALL=1" ];

<<<<<<< HEAD
  meta = {
    description = "Meta loader for Vulkan API";
    homepage = "https://github.com/zeux/volk";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ k900 ];
=======
  meta = with lib; {
    description = "Meta loader for Vulkan API";
    homepage = "https://github.com/zeux/volk";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
