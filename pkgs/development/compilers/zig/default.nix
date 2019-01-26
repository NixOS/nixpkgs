{ stdenv, fetchFromGitHub, cmake, llvmPackages, libxml2, zlib }:

stdenv.mkDerivation rec {
  version = "0.3.0";
  name = "zig-${version}";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = "zig";
    rev = "${version}";
    sha256 = "089ywagxjjh7gxv8h8yg7jpmryzjf7n4m5irhdkhp2966d03kyxm";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmPackages.clang-unwrapped llvmPackages.llvm libxml2 zlib ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = with stdenv.lib; {
    description = "Programming languaged designed for robustness, optimality, and clarity";
    homepage = https://ziglang.org/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}
