{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "snappy-${version}";
  version = "1.1.3";
  
  src = fetchFromGitHub {
    owner = "google";
    repo = "snappy";
    rev = version;
    sha256 = "1w9pq8vag8c6m4ib0qbdbqzsnpwjvw01jbp15lgwg1rzwhvflm10";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

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
