{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "volk";
  version = "1.3.283.0";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "volk";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-AoUStYeSTu6YmdyKgx0n3O+p3asb39GU6HSHgOhhFhQ=";
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
