{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "42";
  rev = "version_${version}";
  name = "binaryen-${version}";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    sha256 = "0b8qc9cd7ncshgfjwv4hfapmwa81gmniaycnxmdkihq9bpm26x2k";
    inherit rev;
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://github.com/WebAssembly/binaryen;
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ asppsa ];
    license = licenses.asl20;
  };
}
