{ stdenv, cmake, python3, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "95";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    sha256 = "1w4js9bm5qv5aws8bzz4f0n3ni2l7h4fidkq9v5bldf0zxncy8m3";
  };

  nativeBuildInputs = [ cmake python3 ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/WebAssembly/binaryen";
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ asppsa ];
    license = licenses.asl20;
  };
}
