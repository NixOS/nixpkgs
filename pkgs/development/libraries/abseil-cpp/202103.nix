{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  static ? stdenv.hostPlatform.isStatic,
  cxxStandard ? null,
}:

stdenv.mkDerivation rec {
  pname = "abseil-cpp";
  version = "20210324.2";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = version;
    sha256 = "sha256-fcxPhuI2eL/fnd6nT11p8DpUNwGNaXZmd03yOiZcOT0=";
  };

  patches = [
    # Use CMAKE_INSTALL_FULL_{LIBDIR,INCLUDEDIR}
    # https://github.com/abseil/abseil-cpp/pull/963
    (fetchpatch {
      url = "https://github.com/abseil/abseil-cpp/commit/5bfa70c75e621c5d5ec095c8c4c0c050dcb2957e.patch";
      sha256 = "0nhjxqfxpi2pkfinnqvd5m4npf9l1kg39mjx9l3087ajhadaywl5";
    })

    # Bacport gcc-13 fix:
    #   https://github.com/abseil/abseil-cpp/pull/1187
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/abseil/abseil-cpp/commit/36a4b073f1e7e02ed7d1ac140767e36f82f09b7c.patch";
      hash = "sha256-aA7mwGEtv/cQINcawjkukmCvfNuqwUeDFssSiNKPdgg=";
    })
  ]
  ++ lib.optionals stdenv.hostPlatform.isLoongArch64 [
    # https://github.com/abseil/abseil-cpp/pull/1110
    (fetchpatch {
      url = "https://github.com/abseil/abseil-cpp/commit/808bc202fc13e85a7948db0d7fb58f0f051200b1.patch";
      hash = "sha256-ayY/aV/xWOdEyFSDqV7B5WDGvZ0ASr/aeBeYwP5RZVc=";
    })
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Don’t propagate the path to CoreFoundation. Otherwise, it’s impossible to build packages
    # that require a different SDK other than the default one.
    ./cmake-core-foundation.patch
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
  ]
  ++ lib.optionals (cxxStandard != null) [
    "-DCMAKE_CXX_STANDARD=${cxxStandard}"
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Open-source collection of C++ code designed to augment the C++ standard library";
    homepage = "https://abseil.io/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.andersk ];
    # Requires LFS64 APIs. 202401 and later are fine.
    broken = stdenv.hostPlatform.isMusl;
  };
}
