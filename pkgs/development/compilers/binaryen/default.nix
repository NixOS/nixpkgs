{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "33";
  rev = "version_${version}";
  name = "binaryen-${version}";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    sha256 = "0zijs2mcgfv0iynwdb0l4zykm0891b1zccf6r8w35ipxvcdwbsbp";
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
