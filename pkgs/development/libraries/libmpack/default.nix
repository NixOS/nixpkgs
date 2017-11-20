{ stdenv, fetchFromGitHub, libtool }:

stdenv.mkDerivation rec {
  name = "libmpack-${version}";
  version = "1.0.5";
  src = fetchFromGitHub {
    owner = "tarruda";
    repo = "libmpack";
    rev = version;
    sha256 = "0rai5djdkjz7bsn025k5489in7r1amagw1pib0z4qns6b52kiar2";
  };
  LIBTOOL = "libtool";
  buildInputs = [ libtool ];
  preInstall = ''
    export PREFIX=$out
  '';
  meta = with stdenv.lib; {
    description = "Simple implementation of msgpack in C";
    homepage = https://github.com/tarruda/libmpack/;
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 garbas ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
