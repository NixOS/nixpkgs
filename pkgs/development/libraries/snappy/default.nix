{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "snappy-${version}";
  version = "1.1.4";
  
  src = fetchurl {
    url = "http://github.com/google/snappy/releases/download/${version}/"
        + "snappy-${version}.tar.gz";
    sha256 = "0mq0nz8gbi1sp3y6xcg0a6wbvnd6gc717f3vh2xrjmfj5w9gwjqk";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ pkgconfig ];

  # -DNDEBUG for speed
  configureFlags = [ "CXXFLAGS=-DNDEBUG" ];

  # SIGILL on darwin
  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/snappy/;
    license = licenses.bsd3;
    description = "Compression/decompression library for very high speeds";
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
