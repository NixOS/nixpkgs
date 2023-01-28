{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "linenoise";
  version = "1.0.10";  # Its version 1.0 plus 10 commits

  src = fetchFromGitHub {
    owner = "antirez";
    repo = "linenoise";
    rev = "c894b9e59f02203dbe4e2be657572cf88c4230c3";
    sha256 = "0wasql7ph5g473zxhc2z47z3pjp42q0dsn4gpijwzbxawid71b4w";
  };

  buildPhase = ./create-pkg-config-file.sh;

  installPhase = ''
    mkdir -p $out/{lib/pkgconfig,src,include}
    cp linenoise.c $out/src/
    cp linenoise.h $out/include/
    cp linenoise.pc $out/lib/pkgconfig/
  '';

  meta = {
    homepage = "https://github.com/antirez/linenoise";
    description = "A minimal, zero-config, BSD licensed, readline replacement";
    maintainers = with lib.maintainers; [ fstamour ];
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd2;
  };
}
