{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xtl";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtl";
    tag = finalAttrs.version;
    hash = "sha256-hhXM2fG3Yl4KeEJlOAcNPVLJjKy9vFlI63lhbmIAsT8=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_TESTS=ON" ];

  doCheck = true;
  nativeCheckInputs = [ doctest ];
  checkTarget = "xtest";

  meta = {
    description = "Basic tools (containers, algorithms) used by other quantstack packages";
    homepage = "https://github.com/xtensor-stack/xtl";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ cpcloud ];
    platforms = lib.platforms.all;
  };
})
