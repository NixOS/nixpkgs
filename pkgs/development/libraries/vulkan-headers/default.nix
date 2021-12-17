{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "vulkan-headers";
  version = "1.2.189.1";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "sdk-${version}";
    sha256 = "1qggc7dv9jr83xr9w2h375wl3pz3rfgrk9hnrjmylkg9gz4p9q03";
  };

  meta = with lib; {
    description = "Vulkan Header files and API registry";
    homepage    = "https://www.lunarg.com";
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
