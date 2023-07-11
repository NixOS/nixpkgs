{ lib
, stdenv
, fetchFromGitHub
, cmake
, doctest
, gtest
}:
stdenv.mkDerivation rec {
  pname = "xtl";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtl";
    rev = version;
    hash = "sha256-Vc1VKOWmG1sAw3UQpNJAhm9PvXSqJ0iO2qLjP6/xjtI=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_TESTS=ON" ];

  doCheck = true;
  nativeCheckInputs = [ doctest ];
  checkTarget = "xtest";

  meta = with lib; {
    description = "Basic tools (containers, algorithms) used by other quantstack packages";
    homepage = "https://github.com/xtensor-stack/xtl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cpcloud ];
    platforms = platforms.all;
  };
}
