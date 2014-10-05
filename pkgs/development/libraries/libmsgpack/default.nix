{ stdenv, fetchurl, cmake}:

stdenv.mkDerivation rec {
  version = "0.5.9";
  name = "libmsgpack-${version}";

  src = fetchurl {
    url = "https://github.com/msgpack/msgpack-c/archive/cpp-${version}.tar.gz";
    sha256 = "0xy204srq5grng7p17hwdxpfzbsfrn89gi4c3k62a23p4f9z0szq";
  };

  buildInputs = [ cmake ];
  patches = [ ./CMakeLists.patch ];

  meta = with stdenv.lib; {
    description = "MessagePack implementation for C and C++";
    homepage = http://msgpack.org;
    maintainers = [ maintainers.redbaron ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
