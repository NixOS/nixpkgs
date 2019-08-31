{ stdenv, fetchFromGitHub
, cmake }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "jwasm";
  version = "git-2017-11-22";

  src = fetchFromGitHub {
    owner = "JWasm";
    repo  = "JWasm";
    rev    = "26f97c8b5c9d9341ec45538701116fa3649b7766";
    sha256 = "0m972pc8vk8s9yv1pi85fsjgm6hj24gab7nalw2q04l0359nqi7w";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = "mkdir -p $out/bin ; cp jwasm $out/bin/";

  meta = {
    description = "A MASM-compatible x86 assembler";
    homepage = http://jwasm.github.io/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
