{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, libffi
, llvm_35
, doCheck ? false
, perl
}:

let version = "20170519";

in stdenv.mkDerivation {
  name = "dale-${version}";

  src = fetchFromGitHub {
    owner = "tomhrr";
    repo = "dale";
    rev = "39e16d8e89fa070de65a673d4462e783d530f95a";
    sha256 = "0dc5cjahv7lzlp92hidlh83rwgrpgb6xz2pnba2pm5xrv2pnsskl";
  };

  buildInputs = [ cmake pkgconfig libffi llvm_35 ]
             ++ stdenv.lib.optional doCheck perl;

  patches = [ ./link-llvm.patch ];

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
