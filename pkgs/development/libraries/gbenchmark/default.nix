{ stdenv, fetchFromGitHub, cmake, gtest }:

stdenv.mkDerivation rec {
  name = "gbenchmark-${version}";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${version}";
    sha256 = "0l1f6azka85fkb8kdmh4qmmpxhsv7lr7wvll6sld31mfz0cai1kd";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gtest ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A microbenchmark support library";
    homepage = https://github.com/google/benchmark;
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ abbradar ];
  };
}
