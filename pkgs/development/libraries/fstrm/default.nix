{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libevent, openssl }:

stdenv.mkDerivation rec {
  pname = "fstrm";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "farsightsec";
    repo = "fstrm";
    rev = "v${version}";
    sha256 = "1vm880h6vpnxqh7v0x17yfim6f2fbxwkm03ms58s2h9akmph9xm5";
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

