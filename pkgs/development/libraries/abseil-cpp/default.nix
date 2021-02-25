{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "abseil-cpp";
  version = "20200923.3";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = version;
    sha256 = "1p4djhm1f011ficbjjxx3n8428p8481p20j4glpaawnpsi362hkl";
  };

  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=17"
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
