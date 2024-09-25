{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, prometheus-cpp
}:

stdenv.mkDerivation rec {
  pname = "gbenchmark";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${version}";
    hash = "sha256-c46Xna/t21WKaFa7n4ieIacsrxJ+15uGNYWCUVuUhsI=";
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

  # Tests fail on 32-bit due to not enough precision
  doCheck = stdenv.hostPlatform.is64bit;

  passthru.tests = {
    inherit prometheus-cpp;
  };

  meta = with lib; {
    description = "Microbenchmark support library";
    homepage = "https://github.com/google/benchmark";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin ++ platforms.freebsd;
    maintainers = with maintainers; [ abbradar ];
  };
}
