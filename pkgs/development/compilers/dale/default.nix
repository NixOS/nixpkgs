{ stdenv, fetchFromGitHub, cmake, libffi, llvm_35, perl }:

let version = "20170416";
    doCheck = false;
in stdenv.mkDerivation {
  name = "dale-${version}";

  src = fetchFromGitHub {
    owner = "tomhrr";
    repo = "dale";
    rev = "ecc5ea91efef8a263c7dddd6925983df5b5258b2";
    sha256 = "0naly7jsfriiqf68q210ay9ppcvidbwwcxksy5zwy1m17aq5kxaw";
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
    license = licenses.mit;
    maintainers = with maintainers; [ amiloradovsky ];
    platforms = platforms.linux;  # fails on Darwin, linking vs. FFI
  };
}
