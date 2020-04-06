{ stdenv, fetchFromGitHub, python, llvmPackages }:

let
  llvm = llvmPackages.llvm;
  clang = llvmPackages.clang;
  clang-unwrapped = llvmPackages.clang-unwrapped;
in

stdenv.mkDerivation {
  name = "libclc-2019-06-09";

  src = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libclc";
    rev = "9f6204ec04a8cadb6bef57caa71e3161c4f398f2";
    sha256 = "03l9frx3iw3qdsb9rrscgzdwm6872gv6mkssvn027ndf9y321xk7";
  };

  nativeBuildInputs = [ python ];
  buildInputs = [ llvm clang clang-unwrapped ];

  postPatch = ''
    sed -i 's,llvm_clang =.*,llvm_clang = "${clang-unwrapped}/bin/clang",' configure.py
    sed -i 's,cxx_compiler =.*,cxx_compiler = "${clang}/bin/clang++",' configure.py
  '';

  configurePhase = ''
    ${python.interpreter} ./configure.py --prefix=$out
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://libclc.llvm.org/;
    description = "Implementation of the library requirements of the OpenCL C programming language";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
