{ stdenv, callPackage, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "gbenchmark-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${version}";
    sha256 = "1y7k73kyxx1jlph23csnhdac76px6ghhwwxbcf0133m4rg0wmpn5";
  };

  buildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A microbenchmark support library";
    homepage = "https://github.com/google/benchmark";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
