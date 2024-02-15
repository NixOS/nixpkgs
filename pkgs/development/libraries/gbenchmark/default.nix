{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, prometheus-cpp
}:

stdenv.mkDerivation rec {
  pname = "gbenchmark";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${version}";
    sha256 = "sha256-gztnxui9Fe/FTieMjdvfJjWHjkImtlsHn6fM1FruyME=";
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
  doCheck = stdenv.is64bit;

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
