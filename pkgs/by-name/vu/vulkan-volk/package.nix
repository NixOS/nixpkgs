{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "volk";
  version = "1.4.363.0";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "volk";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-bewo8ZLkNrM9ja5QdXzfdcPaakKtDH0uV8TtGSTv/Q8=";
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
