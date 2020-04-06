{ stdenv, fetchFromGitHub, cmake, gtest }:

stdenv.mkDerivation rec {
  pname = "gbenchmark";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${version}";
    sha256 = "0r9dbg4cbk47gwmayys31a83m3y67k0kh1f6pl8i869rbd609ndh";
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
    homepage = https://github.com/google/benchmark;
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ abbradar ];
  };
}
