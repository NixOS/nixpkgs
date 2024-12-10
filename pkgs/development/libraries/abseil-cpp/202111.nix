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
  version = "20211102.0";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = version;
    sha256 = "sha256-sSXT6D4JSrk3dA7kVaxfKkzOMBpqXQb0WbMYWG+nGwk=";
  };

  patches = lib.optionals stdenv.isDarwin [
    # Don’t propagate the path to CoreFoundation. Otherwise, it’s impossible to build packages
    # that require a different SDK other than the default one.
    ./cmake-core-foundation.patch
  ];

  cmakeFlags =
    [
      "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
    ]
    ++ lib.optionals (cxxStandard != null) [
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
