{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  name = "vulkan-headers-${version}";
  version = "1.1.101";

  buildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "8e2c4cd554b644592a6d904f2c8000ebbd4aa77f";
    sha256 = "1hb1lg56i2685nz7i4hbsv3sz1iym2wimjz4bfa175xh5jyvr0km";
  };

  meta = with stdenv.lib; {
    description = "Vulkan Header files and API registry";
    homepage    = https://www.lunarg.com;
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
