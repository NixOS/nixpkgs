{ stdenv, fetchFromGitHub, python, llvmPackages }:

let
  llvm = llvmPackages.llvm;
  clang = llvmPackages.clang;
in

stdenv.mkDerivation {
  name = "libclc-2017-11-29";

  src = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "libclc";
    rev = "d6384415ab854c68777dd77451aa2bc0d959da99";
    sha256 = "10fqrlnqlknh58x7pfsbg9r07fblfg2mgq2m4fr1jbb836ncn3wh";
  };

  nativeBuildInputs = [ python ];
  buildInputs = [ llvm clang ];

  postPatch = ''
    sed -i 's,llvm_clang =.*,llvm_clang = "${clang}/bin/clang",' configure.py
    sed -i 's,cxx_compiler =.*,cxx_compiler = "${clang}/bin/clang++",' configure.py
  '';

  configurePhase = ''
    ${python.interpreter} ./configure.py --prefix=$out
  '';

  meta = with stdenv.lib; {
    homepage = http://libclc.llvm.org/;
    description = "Implementation of the library requirements of the OpenCL C programming language";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
