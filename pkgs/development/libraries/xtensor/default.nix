{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, xsimd
, xtl
}:
stdenv.mkDerivation rec {
  pname = "xtensor";
  version = "0.23.10";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtensor";
    rev = version;
    sha256 = "1ayrhyh9x33b87ic01b4jzxc8x27yxpxzya5x54ikazvz8p71n14";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ xtl xsimd ];

  cmakeFlags = [ "-DBUILD_TESTS=ON" ];

  doCheck = true;
  checkInputs = [ gtest ];
  checkTarget = "xtest";

  meta = with lib; {
    description = "Multi-dimensional arrays with broadcasting and lazy computing.";
    homepage = "https://github.com/xtensor-stack/xtensor";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cpcloud ];
    platforms = platforms.all;
  };
}
