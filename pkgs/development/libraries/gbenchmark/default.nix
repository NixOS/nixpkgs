{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, gtest }:

stdenv.mkDerivation rec {
  pname = "gbenchmark";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${version}";
    sha256 = "sha256-yUiFxi80FWBmTZgqmqTMf9oqcBeg3o4I4vKd4djyRWY=";
  };

  nativeBuildInputs = [ cmake ];

  patches = [
    (fetchpatch {
      url = "https://github.com/google/benchmark/commit/2a78e8cbe9b104834d96c78ccc9f9513a29f8c71.patch";
      sha256 = "sha256-Y4OhSi3ceXgpUvYJUJ3NJBFN51j8gEg9AcyXBNtcIRo=";
    })
  ];

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
