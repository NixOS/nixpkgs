# Version specific attributes
{ version, sha256, patches ? (_: [ ]) }:
# Generic attributes
{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, static ? stdenv.hostPlatform.isStatic
, cxxStandard ? null
}:

stdenv.mkDerivation {
  pname = "abseil-cpp";
  inherit version;

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = version;
    inherit sha256;
  };

  patches = patches fetchpatch;

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
