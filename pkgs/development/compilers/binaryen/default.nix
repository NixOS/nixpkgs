{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "44";
  rev = "version_${version}";
  name = "binaryen-${version}";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    sha256 = "0zsqppc05fm62807w6vyccxkk2y2gar7kxbxxixq8zz3xsp6w84p";
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
