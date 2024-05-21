{ lib, stdenv, fetchFromGitHub, cmake, vulkan-headers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "volk";
  version = "1.3.280.0";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "volk";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-e4TLGRqn0taYeiRVxc9WevURjO5dsVq3RpOwZBGDknQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ vulkan-headers ];

  cmakeFlags = ["-DVOLK_INSTALL=1"];

  meta = with lib; {
    description = " Meta loader for Vulkan API";
    homepage = "https://github.com/zeux/volk";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
  };
})
