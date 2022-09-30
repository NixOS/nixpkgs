{ lib
, fetchFromGitHub
, cmake
, pkg-config
, llvmPackages_13
, libffi
, doCheck ? false
, perl
}:

llvmPackages_13.stdenv.mkDerivation rec {
  pname = "dale";
  version = "unstable-2022-04-11";

  src = fetchFromGitHub {
    owner = "tomhrr";
    repo = "dale";
    rev = "7386ef2d8912c60c6fb157a1e5cd772e15eaf658";
    sha256 = "sha256-LNWqrFuEjtL7zuPTBfe4qQWr8IrT/ldQWSeDTK3Wqmo=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libffi llvmPackages_13.llvm ];

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
  };
}
