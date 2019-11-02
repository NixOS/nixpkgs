{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libevent, openssl }:

stdenv.mkDerivation rec {
  pname = "fstrm";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "farsightsec";
    repo = "fstrm";
    rev = "v${version}";
    sha256 = "0b6x9wgyn92vykkmd3ynhnpbdl77zb4wf4rm7p0h8p9pwq953hdm";
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

