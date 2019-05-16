{ stdenv, fetchFromGitHub, cmake, llvmPackages, libxml2, zlib }:

stdenv.mkDerivation rec {
  version = "0.4.0";
  pname = "zig";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = version;
    sha256 = "1cq6cc5pvybz9kn3y0j5gskkjq88hkmmcsva54mfzpcc65l3pv6p";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmPackages.clang-unwrapped llvmPackages.llvm libxml2 zlib ];

  meta = with stdenv.lib; {
    description = "Programming languaged designed for robustness, optimality, and clarity";
    homepage = https://ziglang.org/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}
