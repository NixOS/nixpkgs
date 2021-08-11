{ lib, stdenv, fetchFromGitHub, cmake, gtest }:

stdenv.mkDerivation rec {
  pname = "gbenchmark";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${version}";
    sha256 = "sha256-h/e2vJacUp7PITez9HPzGc5+ofz7Oplso44VibECmsI=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    cp -r ${gtest.src} googletest
    chmod -R u+w googletest
  '';

  doCheck = true;

  meta = with lib; {
    description = "A microbenchmark support library";
    homepage = "https://github.com/google/benchmark";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ abbradar ];
  };
}
