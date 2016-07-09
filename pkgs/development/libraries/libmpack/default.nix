{ stdenv, fetchFromGitHub, libtool }:

stdenv.mkDerivation rec {
  name = "libmpack-${version}";
  version = "1.0.3-rev${rev}";
  rev = "071d944c9ff7b7fbd2c3c19d1fd1a231363ddeea";
  src = fetchFromGitHub {
    owner = "tarruda";
    repo = "libmpack";
    inherit rev;
    sha256 = "1h3pbmykm69gfyi0wz647gz5836a6f3jc4azzll7i3mkpc11gcrd";
  };
  LIBTOOL = "libtool";
  buildInputs = [ libtool ];
  installPhase = ''
    mkdir -p $out/lib/libmpack
    cp -R build/* $out/lib/libmpack
    rm -rf $out/lib/libmpack/debug
  '';
  meta = with stdenv.lib; {
    description = "Simple implementation of msgpack in C";
    homepage = "https://github.com/tarruda/libmpack/";
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 garbas ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
