{ stdenv, fetchurl, autoconf, automake, libtool, ruby }:

stdenv.mkDerivation rec {
  version = "0.5.8";
  name = "libmsgpack-${version}";

  src = fetchurl {
    url = "https://github.com/msgpack/msgpack-c/archive/cpp-${version}.tar.gz";
    sha256 = "1h6k9kdbfavmw3by5kk3raszwa64hn9k8yw9rdhvl5m8g2lks89k";
  };

  buildInputs = [ autoconf automake libtool ruby ];

  outputs = [ "out" "lib" ];

  preConfigure = "./bootstrap";

  postInstall = ''
    mkdir -p $lib/lib
    mv $out/lib/*.so.* $lib/lib/
  '';

  meta = with stdenv.lib; {
    description = "MessagePack implementation for C and C++";
    homepage = http://msgpack.org;
    maintainers = [ maintainers.redbaron ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
