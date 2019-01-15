{ stdenv, cmake, fetchFromGitHub, python3, emscriptenRev ? null }:

let
  defaultVersion = "63";

  # Map from git revs to SHA256 hashes
  sha256s = {
    "version_63" = "0qd6kxiaqrwm4hsxvx4z6nv20z4arnfr1ks4zjavnw0nzn1n6m3s";
    "1.38.22" = "0qnkwyb9ylpk24gl5rdj526601z0p9wclg8rdx7b2bl1cydfa8sf";
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

  nativeBuildInputs = [ cmake python3 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/WebAssembly/binaryen;
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ asppsa ];
    license = licenses.asl20;
  };
}
