{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "snappy-1.1.2";
  
  src = fetchFromGitHub {
    owner = "google";
    repo = "snappy";
    rev = "1ff9be9b8fafc8528ca9e055646f5932aa5db9c4";
    sha256 = "1zyjj13max0z42g3ii54n3qn7rbcga34dbi26lpm7v5ya752shx7";
  };

  buildInputs = [ pkgconfig autoreconfHook ];

  preConfigure = ''
    sh autogen.sh
  '';

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
