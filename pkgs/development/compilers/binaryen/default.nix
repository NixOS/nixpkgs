{ stdenv, cmake, fetchFromGitHub, emscriptenRev ? null }:

let
  defaultVersion = "46";

  # Map from git revs to SHA256 hashes
  sha256s = {
    "version_46" = "1ak4nas848mdggqkc9wkwn5gc4i1kx7jw28c4rksf1if80yy9kxg";
    "1.37.36" = "1ak4nas848mdggqkc9wkwn5gc4i1kx7jw28c4rksf1if80yy9kxg";
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

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://github.com/WebAssembly/binaryen;
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ asppsa ];
    license = licenses.asl20;
  };
}
