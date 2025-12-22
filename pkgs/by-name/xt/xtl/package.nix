{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xtl";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtl";
    tag = finalAttrs.version;
    hash = "sha256-KgCqGgRr4s7+rSyCzOfPZwS6CIZavV2pIhb+IPWoYTg=";
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
