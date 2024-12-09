{ lib
, stdenv
, fetchFromGitHub
, cmake
, doctest
}:
stdenv.mkDerivation rec {
  pname = "xtl";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtl";
    rev = version;
    hash = "sha256-f8qYh8ibC/ToHsUv3OF1ujzt3fUe7kW9cNpGyLqsgqw=";
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
