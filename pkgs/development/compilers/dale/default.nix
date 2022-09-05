{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libffi
, llvm_6
, doCheck ? false
, perl
}:

stdenv.mkDerivation {
  pname = "dale";
  version = "20181024";

  src = fetchFromGitHub {
    owner = "tomhrr";
    repo = "dale";
    rev = "f5db8b486f4e7c423fc25941a8315f1209bc0e54";
    sha256 = "0v4ajrzrqvf279kd7wsd9flrpsav57lzxlwwimk9vnfwh7xpzf9v";
  };

  nativeBuildInputs = [ cmake pkg-config llvm_6.dev ];
  buildInputs = [ libffi llvm_6 ];

  inherit doCheck;
  checkInputs = [ perl ];

  checkTarget = "tests";

  meta = with lib; {
    description = "Lisp-flavoured C";
    longDescription = ''
      Dale is a system (no GC) programming language that uses
      S-expressions for syntax and supports syntactic macros.
    '';
    homepage = "https://github.com/tomhrr/dale";
    license = licenses.bsd3;
    maintainers = with maintainers; [ amiloradovsky ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    # failed on Darwin: linker couldn't find the FFI lib
    # failed on AArch64: because LLVM 3.5 is failed there
  };
}
