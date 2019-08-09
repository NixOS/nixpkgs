{ stdenv, cmake, python, fetchFromGitHub, emscriptenRev ? null }:

let
  defaultVersion = "88";

  # Map from git revs to SHA256 hashes
  sha256s = {
    "version_88" = "14vm2hksn696klk97yz562mm5sqd67qbbzmlw4kvy22ldyc6sgmi";
    "1.38.28" = "172s7y5f38736ic8ri3mnbdqcrkadd40a26cxcfwbscc53phl11v";
  };
in

stdenv.mkDerivation rec {
  version = if emscriptenRev == null
            then defaultVersion
            else "emscripten-${emscriptenRev}";
  rev = if emscriptenRev == null
        then "version_${version}"
        else emscriptenRev;
  name = "binaryen-${version}";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    sha256 =
      if builtins.hasAttr rev sha256s
      then builtins.getAttr rev sha256s
      else null;
    inherit rev;
  };

  nativeBuildInputs = [ cmake python ];

  meta = with stdenv.lib; {
    homepage = https://github.com/WebAssembly/binaryen;
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ asppsa ];
    license = licenses.asl20;
  };
}
