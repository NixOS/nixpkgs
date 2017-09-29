{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libevent, openssl }:

stdenv.mkDerivation rec {
  name = "fstrm-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "farsightsec";
    repo = "fstrm";
    rev = "v${version}";
    sha256 = "135m0d4z1wbiaazs3bh6z53a35mgs33gvfki8pl4xfaw9cfcfpd2";
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

