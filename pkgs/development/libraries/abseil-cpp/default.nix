{ lib, stdenv, fetchFromGitHub, cmake, static ? stdenv.hostPlatform.isStatic }:

stdenv.mkDerivation rec {
  pname = "abseil-cpp";
  version = "20210324.0";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = version;
    sha256 = "sha256-8MwDKkvIT+dfM1uZlvtbAY41AJcezMLi+J4lz5xXlD8=";
  };

  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=17"
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
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
