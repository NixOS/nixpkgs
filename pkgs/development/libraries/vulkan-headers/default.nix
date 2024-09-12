{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "vulkan-headers";
  version = "1.3.290.0";

  nativeBuildInputs = [ cmake ];

  # TODO: investigate why <algorithm> isn't found
  cmakeFlags = lib.optionals stdenv.isDarwin [ "-DVULKAN_HEADERS_ENABLE_MODULE=OFF" ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "vulkan-sdk-${version}";
    hash = "sha256-goxA3Wg3u5hNCz54tWMJnFaS0JGVjphy14Ng/sAK/EM=";
  };

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Vulkan Header files and API registry";
    homepage    = "https://www.lunarg.com";
    platforms   = platforms.unix ++ platforms.windows;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
