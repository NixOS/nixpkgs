{ lib, stdenv, fetchFromGitHub, cmake, cxxopts }:

stdenv.mkDerivation rec {
  pname = "ada";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "ada-url";
    repo = "ada";
    rev = "v${version}";
    hash = "sha256-jIXZ8TSLMucwvZc+PMQvNBjvhv2S/0Dh6qTTazYv90A=";
  };

  postPatch = ''
    substituteInPlace tools/CMakeLists.txt \
      --replace "import_dependency(cxxopts" "#import_dependency(cxxopts" \
      --replace "add_dependency(cxxopts)" "find_package(cxxopts REQUIRED)"
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    cxxopts
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = with lib; {
    description = "WHATWG-compliant URL parser written in modern C++";
    homepage = "https://ada-url.github.io/ada/";
    license = [ licenses.asl20 /* or */ licenses.mit ];
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
