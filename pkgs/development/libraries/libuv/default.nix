{ stdenv, lib, fetchFromGitHub, autoconf, automake, libtool, pkgconfig

, ApplicationServices, CoreServices }:

stdenv.mkDerivation rec {
  version = "1.9.0";
  name = "libuv-${version}";

  src = fetchFromGitHub {
    owner = "libuv";
    repo = "libuv";
    rev = "v${version}";
    sha256 = "0sq8c8n7xixn2xxp35crprvh35ry18i5mcxgwh12lydwv9ks0d4k";
  };

  buildInputs = [ automake autoconf libtool pkgconfig ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ ApplicationServices CoreServices ];

  preConfigure = ''
    LIBTOOLIZE=libtoolize ./autogen.sh
  '';

  meta = with lib; {
    description = "A multi-platform support library with a focus on asynchronous I/O";
    homepage    = https://github.com/libuv/libuv;
    maintainers = with maintainers; [ cstrahan ];
    platforms   = with platforms; linux ++ darwin;
  };

}
