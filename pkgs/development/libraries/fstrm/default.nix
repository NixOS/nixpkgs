{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libevent, openssl }:

stdenv.mkDerivation rec {
  name = "fstrm-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "farsightsec";
    repo = "fstrm";
    rev = "v${version}";
    sha256 = "11i8b3wy6j3z3fcv816xccxxlrfkczdr8bm2gnan6yv4ppbji4ny";
  };

  outputs = [ "bin" "out" "dev" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libevent openssl ];

  preBuild = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -L${openssl}/lib"
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Frame Streams implementation in C";
    homepage = https://github.com/farsightsec/fstrm;
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}

