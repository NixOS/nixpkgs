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

  cmakeFlags = [
    # We ran into issues with gtest 1.8.5 conditioning on
    # `#if __has_cpp_attribute(maybe_unused)`, which was, for some
    # reason, going through even when C++14 was being used and
    # breaking the build on Darwin by triggering warnings about using
    # C++17 features.
    #
    # This might be a problem with our Clang, as it does not reproduce
    # with Xcode, but since `-Werror` is painful for us anyway and
    # upstream exposes a CMake flag to turn it off, we just use that.
    (lib.cmakeBool "BENCHMARK_ENABLE_WERROR" false)
  ];

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
