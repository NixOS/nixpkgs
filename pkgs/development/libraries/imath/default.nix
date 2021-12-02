{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "imath";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "imath";
    rev = "v${version}";
    sha256 = "sha256-LoyV1Wtugva6MTpREstP2rYMrHW2xR0qfEAIV1Fo1Ns=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Imath is a C++ and python library of 2D and 3D vector, matrix, and math operations for computer graphics";
    homepage = "https://github.com/AcademySoftwareFoundation/Imath";
    license = licenses.bsd3;
    maintainers = with maintainers; [ paperdigits ];
    platforms = platforms.all;
  };
}
