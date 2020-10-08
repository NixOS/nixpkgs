{ stdenv, fetchFromGitHub, cmake, gtest }:

stdenv.mkDerivation rec {
  pname = "gbenchmark";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${version}";
    sha256 = "13rxagpzw6bal6ajlmrxlh9kgfvcixn6j734b2bvfqz7lch8n0pa";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    cp -r ${gtest.src} googletest
    chmod -R u+w googletest
  '';

  enableParallelBuilding = true;
  doCheck = true;

  meta = with stdenv.lib; {
    description = "A microbenchmark support library";
    homepage = "https://github.com/google/benchmark";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ abbradar ];
  };
}
