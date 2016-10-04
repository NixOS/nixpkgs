{ stdenv, lib, fetchFromGitHub, autoconf, automake, libtool, pkgconfig

, ApplicationServices, CoreServices }:

stdenv.mkDerivation rec {
  version = "1.9.1";
  name = "libuv-${version}";

  src = fetchFromGitHub {
    owner = "libuv";
    repo = "libuv";
    rev = "v${version}";
    sha256 = "1kc386gkkkymgz9diz1z4r8impcsmki5k88dsiasd6v9bfvq04cc";
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
