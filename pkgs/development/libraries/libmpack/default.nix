{ stdenv, fetchFromGitHub, libtool }:

stdenv.mkDerivation rec {
  name = "libmpack-${version}";
  version = "1.0.2";
  src = fetchFromGitHub {
    owner = "tarruda";
    repo = "libmpack";
    rev = version;
    sha256 = "0s391vyz1gv4j95zdyvxspw7c0xq7d7b4fh0yxrgqqqp5js1rlj0";
  };
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
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.linux;
  };
}
