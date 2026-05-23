{ lib, stdenv, fetchFromGitHub, llvmPackages, ... }:

stdenv.mkDerivation rec {
  pname = "jank";
  version = "unstable-2026-05-22";

  src = fetchFromGitHub {
    owner = "jank-lang";
    repo = "jank";
    rev = "86cd33b8edb7504209719f43391a185b84211a0c";
    hash = "sha256-vZ/jTwGjoJsHsaOmgrPwUkUSXk8NGBpBkElg21oqB/U=";
  };

  buildInputs = [ llvmPackages.llvm ];

  meta = with lib; {
    description = "The native Clojure dialect hosted on LLVM";
    homepage = "https://jank-lang.org";
    license = licenses.mpl20;
    maintainers = with maintainers; [ arik ];
  };
}
