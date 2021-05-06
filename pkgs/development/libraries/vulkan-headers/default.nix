{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "vulkan-headers";
  version = "1.2.176.0";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "sdk-${version}";
    sha256 = "07i5p73f5n1qxd435495a3c6ss6j9f4gljq5h4i8b5p5isgh6zvd";
  };

  meta = with lib; {
    description = "Vulkan Header files and API registry";
    homepage    = "https://www.lunarg.com";
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
