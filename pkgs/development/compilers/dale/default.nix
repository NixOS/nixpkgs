{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libffi
, llvm_10
, doCheck ? false
, perl
}:

stdenv.mkDerivation rec {
  pname = "dale";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "tomhrr";
    repo = "dale";
    rev = version;
    sha256 = "sha256-sFAbJf8LIEj8WXONgE/9t/+woJ6SkbN++xIqqAyDpa4=";
  };

  nativeBuildInputs = [ cmake pkg-config llvm_10.dev ];
  buildInputs = [ libffi llvm_10 ];

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
    platforms = with platforms; [ "i686-linux" "x86_64-linux" ];
    # failed on Darwin: linker couldn't find the FFI lib
    # failed on AArch64: because LLVM 3.5 is failed there
  };
}
