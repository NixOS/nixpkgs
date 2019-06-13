{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  name = "vulkan-headers-${version}";
  version = "1.1.106";

  buildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "sdk-${version}";
    sha256 = "0idw7q715ikj575qmspvgq2gzc6c1sj581b8z3xnv6wz9qbzrmsd";
  };

  meta = with stdenv.lib; {
    description = "Vulkan Header files and API registry";
    homepage    = https://www.lunarg.com;
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
