{ stdenv, fetchFromGitHub }:

let
  version = "2.9.2";
in stdenv.mkDerivation {
  name = "http-parser-${version}";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "http-parser";
    rev = "v${version}";
    sha256 = "1qs6x3n2nrcj1wiik5pg5i16inykf7rcfdfdy7rwyzf40pvdl3c2";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";
  patches = [ ./build-shared.patch ];
  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];
  buildFlags = "library";
  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "An HTTP message parser written in C";
    homepage = https://github.com/nodejs/http-parser;
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
