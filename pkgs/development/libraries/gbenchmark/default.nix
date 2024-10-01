{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, gtest
, prometheus-cpp
}:

stdenv.mkDerivation rec {
  pname = "gbenchmark";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${version}";
    hash = "sha256-5cl1PIjhXaL58kSyWZXRWLq6BITS2BwEovPhwvk2e18=";
  };

  nativeBuildInputs = [ cmake ninja ];

  postPatch = ''
    cp -r ${gtest.src} googletest
    chmod -R u+w googletest
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
