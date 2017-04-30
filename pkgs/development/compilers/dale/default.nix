{ stdenv, fetchFromGitHub, cmake, libffi, llvm_35, perl }:

let version = "20170419";
    doCheck = false;
in stdenv.mkDerivation {
  name = "dale-${version}";

  src = fetchFromGitHub {
    owner = "tomhrr";
    repo = "dale";
    rev = "64e072d0520a134b9ae8038104fa977776b6e0af";
    sha256 = "1apvq3v6ra8x0sj8gg9yavqsyxiggh2wnh1zbw2ccpg723bssl4a";
  };

  buildInputs = [ cmake libffi llvm_35 ] ++
                stdenv.lib.optional doCheck perl;

  inherit doCheck;

  checkTarget = "tests";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Lisp-flavoured C";
    longDescription = ''
      Dale is a system (no GC) programming language that uses
      S-expressions for syntax and supports syntactic macros.
    '';
    homepage = "https://github.com/tomhrr/dale";
    license = licenses.bsd3;
    maintainers = with maintainers; [ amiloradovsky ];
    platforms = with platforms; [ "i686-linux" "x86_64-linux" ];
    # failed on Darwin: linker couldn't find the FFI lib
    # failed on AArch64: because LLVM 3.5 is failed there
  };
}
