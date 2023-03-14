{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, prometheus-cpp
}:

stdenv.mkDerivation rec {
  pname = "gbenchmark";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${version}";
    sha256 = "sha256-gg3g/0Ki29FnGqKv9lDTs5oA9NjH23qQ+hTdVtSU+zo=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    cp -r ${gtest.src} googletest
    chmod -R u+w googletest

    # https://github.com/google/benchmark/issues/1396
    substituteInPlace cmake/benchmark.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  doCheck = true;

  passthru.tests = {
    inherit prometheus-cpp;
  };

  meta = with lib; {
    description = "A microbenchmark support library";
    homepage = "https://github.com/google/benchmark";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ abbradar ];
  };
}
