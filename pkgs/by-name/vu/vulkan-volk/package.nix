{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "volk";
  version = "1.4.304.0";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "volk";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-+SLGRvCUKFntz60/xL/NjoFjvvATWMImR4CGnCHUj2o=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ vulkan-headers ];

  cmakeFlags = [ "-DVOLK_INSTALL=1" ];

  meta = with lib; {
    description = " Meta loader for Vulkan API";
    homepage = "https://github.com/zeux/volk";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
  };
})
