{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "volk";
  version = "1.4.350";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "volk";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-7JsOWhMTnxeJfsTVgnnHQt5gYJ8tqELT+s3VDHTPof8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ vulkan-headers ];

  cmakeFlags = [ "-DVOLK_INSTALL=1" ];

  meta = {
    description = "Meta loader for Vulkan API";
    homepage = "https://github.com/zeux/volk";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ k900 ];
  };
})
