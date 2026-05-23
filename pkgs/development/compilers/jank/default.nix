# pkgs/development/compilers/jank/default.nix
{ lib, stdenv, fetchFromGitHub, llvmPackages, ... }:

stdenv.mkDerivation rec {
  pname = "jank";
  # Replace with the latest target version
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "jank-lang";
    repo = "jank";
    rev = "v${version}";
    # Temporarily use fakeHash to force Nix to output the correct hash during the first build
    hash = lib.fakeHash;
  };

  # jank requires LLVM and C++ build inputs
  buildInputs = [ llvmPackages.llvm ];

  meta = with lib; {
    description = "The native Clojure dialect hosted on LLVM";
    homepage = "https://jank-lang.org";
    license = licenses.mpl20;
    # Add yourself as the maintainer
    maintainers = [ maintainers.arik ];
  };
}
