{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, gtest
, static ? stdenv.hostPlatform.isStatic
, cxxStandard ? null
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abseil-cpp";
  version = "20230125.4";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-7C/QIXYRyUyNVVE0tqmv8b5g/uWc58iBI5jzdtddQ+U=";
  };

  patches = [
    # Fixes: clang++: error: unsupported option '-msse4.1' for target 'aarch64-apple-darwin'
    # https://github.com/abseil/abseil-cpp/pull/1707
    (fetchpatch {
      name = "fix-compile-breakage-on-darwin";
      url = "https://github.com/abseil/abseil-cpp/commit/6dee153242d7becebe026a9bed52f4114441719d.patch";
      hash = "sha256-r6QnHPnwPwOE/hv4kLNA3FqNq2vU/QGmwAc5q0/q1cs=";
    })
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Don’t propagate the path to CoreFoundation. Otherwise, it’s impossible to build packages
    # that require a different SDK other than the default one.
    ./cmake-core-foundation.patch
  ];

  cmakeFlags = [
    "-DABSL_BUILD_TEST_HELPERS=ON"
    "-DABSL_USE_EXTERNAL_GOOGLETEST=ON"
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
  ] ++ lib.optionals (cxxStandard != null) [
    "-DCMAKE_CXX_STANDARD=${cxxStandard}"
  ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gtest ];

  meta = with lib; {
    description = "Open-source collection of C++ code designed to augment the C++ standard library";
    homepage = "https://abseil.io/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.andersk ];
    # Requires LFS64 APIs. 202401 and later are fine.
    broken = stdenv.hostPlatform.isMusl;
  };
})
