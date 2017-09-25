{ stdenv, fetchFromGitHub, libtool }:

stdenv.mkDerivation rec {
  name = "libmpack-${version}";
  version = "1.0.3-rev${rev}";
  rev = "80bd55ea677e70b041f65a4b99438c1f059cce4b";
  src = fetchFromGitHub {
    owner = "tarruda";
    repo = "libmpack";
    inherit rev;
    sha256 = "1whnbgxd5580h59kvc2xgx6ymw7nk9kz6r4ajgsfv6c6h2xbwbl3";
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
    homepage = https://github.com/tarruda/libmpack/;
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 garbas ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
