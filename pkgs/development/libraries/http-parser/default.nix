{ stdenv, fetchurl }:

let
  version = "2.9.1";
in stdenv.mkDerivation {
  name = "http-parser-${version}";

  src = fetchurl {
    url = "https://github.com/joyent/http-parser/archive/v${version}.tar.gz";
    sha256 = "08fypqh3jkwvlznvmwwwir53ffg2xcxy0v8bjz6wxjlb41qhf8ik";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";
  patches = [ ./build-shared.patch ];
  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];
  buildFlags = "library";
  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "An HTTP message parser written in C";
    homepage = https://github.com/joyent/http-parser;
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
