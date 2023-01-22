{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
}:
stdenv.mkDerivation rec {
  pname = "xtl";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtl";
    rev = version;
    sha256 = "huCmkWyasB9EV32waBB9IY86LsSjggp0b6Wz5Op+l4w=" ;
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_TESTS=ON" ];

  doCheck = true;
  nativeCheckInputs = [ gtest ];
  checkTarget = "xtest";

  meta = with lib; {
    description = "Basic tools (containers, algorithms) used by other QuantStack packages";
    homepage = "https://github.com/xtensor-stack/xtl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cpcloud ];
    platforms = platforms.all;
  };
}
