{ stdenv, callPackage, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "gbenchmark-${version}";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${version}";
    sha256 = "1gld3zdxgc0c0466qvnsi70h2ksx8qprjrx008rypdhzp6660m48";
  };

  buildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A microbenchmark support library";
    homepage = https://github.com/google/benchmark;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
