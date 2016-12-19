{ stdenv, lib, fetchFromGitHub, autoconf, automake, libtool, pkgconfig

, ApplicationServices, CoreServices }:

stdenv.mkDerivation rec {
  version = "1.10.1";
  name = "libuv-${version}";

  src = fetchFromGitHub {
    owner = "libuv";
    repo = "libuv";
    rev = "v${version}";
    sha256 = "0gna53fgsjjs38kv1g20xfaalv0fk3xncb6abga3saswrv283hx0";
  };

  # these checks are probably network-dependent
  postPatch = lib.optionalString doCheck ''
    sed '/getnameinfo_basic/d' -i test/test-list.h
  '';

  buildInputs = [ automake autoconf libtool pkgconfig ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ ApplicationServices CoreServices ];

  preConfigure = ''
    LIBTOOLIZE=libtoolize ./autogen.sh
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "A multi-platform support library with a focus on asynchronous I/O";
    homepage    = https://github.com/libuv/libuv;
    maintainers = with maintainers; [ cstrahan ];
    platforms   = with platforms; linux ++ darwin;
  };

}
