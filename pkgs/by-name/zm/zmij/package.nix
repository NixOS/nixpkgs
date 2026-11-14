{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zmij";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "vitaut";
    repo = "zmij";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2tppKuONy9IS5IzGJF+4bqAav3aaQMZjiQCMoi5WscE=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "ZMIJ_TEST" false)
    (lib.cmakeBool "ZMIJ_EXAMPLE" false)
  ];

  meta = {
    description = "Fast floating-point-to-string conversion library";
    homepage = "https://github.com/vitaut/zmij";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ schembriaiden ];
    platforms = lib.platforms.all;
  };
})
