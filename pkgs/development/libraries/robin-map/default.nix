{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "robin-map";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Tessil";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-h59khOUg7vzw64EAMT/uzTKHzx2M9q+pc2BhfGQiY3Q=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/Tessil/robin-map";
    description = "C++ implementation of a fast hash map and hash set using robin hood hashing";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu jtojnar ];
    platforms = platforms.unix;
  };
}
