{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, static ? stdenv.hostPlatform.isStatic
, cxxStandard ? null
}:

stdenv.mkDerivation rec {
  pname = "abseil-cpp";
  version = "20220623.1";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "refs/tags/${version}";
    hash = "sha256-Od1FZOOWEXVQsnZBwGjDIExi6LdYtomyL0STR44SsG8=";
  };

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
