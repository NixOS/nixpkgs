{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "snappy-${version}";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "snappy";
    rev = "${version}";
    sha256 = "1x7r8sjmdqlqjz0xfiwdyrqpgaj5yrvrgb28ivgpvnxgar5qv6m2";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  # -DNDEBUG for speed
  configureFlags = [ "CXXFLAGS=-DNDEBUG" ];

  # SIGILL on darwin
  doCheck = !stdenv.isDarwin;
  checkPhase = ''
    (cd .. && ./build/snappy_unittest)
  '';

  meta = with stdenv.lib; {
    homepage = https://google.github.io/snappy/;
    license = licenses.bsd3;
    description = "Compression/decompression library for very high speeds";
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
