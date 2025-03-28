{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
}:
stdenv.mkDerivation rec {
  pname = "xtl";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtl";
    rev = version;
    hash = "sha256-hhXM2fG3Yl4KeEJlOAcNPVLJjKy9vFlI63lhbmIAsT8=";
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
