{ stdenv, cmake, python3, fetchFromGitHub, emscriptenRev ? null, substituteAll }:

let
  defaultVersion = "93";

  # Map from git revs to SHA256 hashes
  sha256s = {
    version_93 = "15y3703ha6mxcq168br0wlydas5rq66msrcsd650zrjz0ndxwsfx";
    "1.39.1" = "0ygm9m5322h4vfpf3j63q32qxk2l26yk62hh7dkb49j51zwl1y3y";
  };
in

stdenv.mkDerivation rec {
  version = if emscriptenRev == null
            then defaultVersion
            else "emscripten-${emscriptenRev}";
  rev = if emscriptenRev == null
        then "version_${version}"
        else emscriptenRev;
  pname = "binaryen";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    sha256 =
      if builtins.hasAttr rev sha256s
      then builtins.getAttr rev sha256s
      else null;
    inherit rev;
  };

  patches = stdenv.lib.optional (emscriptenRev != null) (substituteAll {
    src = ./0001-Get-rid-of-git-dependency.patch;
    emscriptenv = "1.39.1";
  });

  nativeBuildInputs = [ cmake python3 ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/WebAssembly/binaryen";
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ asppsa ];
    license = licenses.asl20;
  };
}
