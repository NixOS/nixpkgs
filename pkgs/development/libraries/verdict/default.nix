{ stdenv
, lib
, fetchFromGitHub
, cmake
, gtest
}:

stdenv.mkDerivation rec {
  pname = "verdict";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "sandialabs";
    repo = "verdict";
    rev = version;
    sha256 = "GvCL1yxYIvZWgIf3QSSCsKDhzDTAttB7t7uUGVXponM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  checkInputs = [
    gtest
  ];

  doCheck = true;

  meta = with lib; {
    description = "Compute quality functions of 2 and 3-dimensional regions";
    homepage = "https://github.com/sandialabs/verdict";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
