{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "vulkan-headers";
  version = "1.2.131.1";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "sdk-${version}";
    sha256 = "1yf42c2cnhx1y4wkxsdl6g653xl2vvamhpkldz6jb4ca5wk03gxf";
  };

  meta = with stdenv.lib; {
    description = "Vulkan Header files and API registry";
    homepage    = https://www.lunarg.com;
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
