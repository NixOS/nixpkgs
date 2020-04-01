{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, libffi
, llvm_6
, doCheck ? false
, perl
}:

let version = "20181024";

in stdenv.mkDerivation {
  pname = "dale";
  inherit version;

  src = fetchFromGitHub {
    owner = "tomhrr";
    repo = "dale";
    rev = "f5db8b486f4e7c423fc25941a8315f1209bc0e54";
    sha256 = "0v4ajrzrqvf279kd7wsd9flrpsav57lzxlwwimk9vnfwh7xpzf9v";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake libffi llvm_6 ]
             ++ stdenv.lib.optional doCheck perl;

  inherit doCheck;

  checkTarget = "tests";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Lisp-flavoured C";
    longDescription = ''
      Dale is a system (no GC) programming language that uses
      S-expressions for syntax and supports syntactic macros.
    '';
    homepage = https://github.com/tomhrr/dale;
    license = licenses.bsd3;
    maintainers = with maintainers; [ amiloradovsky ];
    platforms = with platforms; [ "i686-linux" "x86_64-linux" ];
    # failed on Darwin: linker couldn't find the FFI lib
    # failed on AArch64: because LLVM 3.5 is failed there
  };
}
