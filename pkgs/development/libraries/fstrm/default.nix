{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libevent }:

stdenv.mkDerivation rec {
  name = "fstrm-${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "farsightsec";
    repo = "fstrm";
    rev = "v${version}";
    sha256 = "1n8hpywjgkzm0xh0hvryf5r6v2sbpgr3qy0grxq9yha7kqcam4f3";
  };

  outputs = [ "bin" "out" "dev" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libevent ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Frame Streams implementation in C";
    homepage = https://github.com/farsightsec/fstrm;
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}

