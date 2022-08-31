{ lib, stdenv, fetchFromGitHub, libtool }:

stdenv.mkDerivation rec {
  pname = "libmpack";
  version = "1.0.5";
  src = fetchFromGitHub {
    owner = "libmpack";
    repo = "libmpack";
    rev = version;
    sha256 = "0rai5djdkjz7bsn025k5489in7r1amagw1pib0z4qns6b52kiar2";
  };

  makeFlags = [ "LIBTOOL=${libtool}/bin/libtool" "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple implementation of msgpack in C";
    homepage = "https://github.com/tarruda/libmpack/";
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
