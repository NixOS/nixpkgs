{ lib
, stdenv
, fetchFromGitHub
, cmake
, static ? stdenv.hostPlatform.isStatic
, cxxStandard ? null
}:

stdenv.mkDerivation rec {
  pname = "abseil-cpp";
  version = "20220623.2";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "refs/tags/${version}";
    hash = "sha256-ma8QJfSySsk2XVLA0rhwYJMQx+6HxMFgub6gi5mDrLI=";
  };

  patches = lib.optionals stdenv.isDarwin [
    # Don’t propagate the path to CoreFoundation. Otherwise, it’s impossible to build packages
    # that require a different SDK other than the default one.
    ./cmake-core-foundation.patch
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
  ] ++ lib.optionals (cxxStandard != null) [
    "-DCMAKE_CXX_STANDARD=${cxxStandard}"
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An open-source collection of C++ code designed to augment the C++ standard library";
    homepage = "https://abseil.io/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.andersk ];
  };
}
