{ stdenv, fetchFromGitHub }:

let
  version = "2.9.3";
in stdenv.mkDerivation {
  pname = "http-parser";
  inherit version;

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "http-parser";
    rev = "v${version}";
    sha256 = "189zi61vczqgmqjd2myjcjbbi5icrk7ccs0kn6nj8hxqiv5j3811";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";
  patches = [ ./build-shared.patch ];
  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];
  buildFlags = [ "library" ];
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
