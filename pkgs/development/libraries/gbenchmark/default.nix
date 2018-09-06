{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "gbenchmark-${version}";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${version}";
    sha256 = "1qx2dp7y0haj6wfbbfw8hx8sxb8ww0igdfrmmaaxfl0vhckylrxh";
  };

  buildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A microbenchmark support library";
    homepage = https://github.com/google/benchmark;
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ abbradar ];
  };
}
