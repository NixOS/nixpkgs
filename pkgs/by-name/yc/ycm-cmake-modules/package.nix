{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ycm-cmake-modules";
  version = "0.18.5";
  src = fetchFromGitHub {
    owner = "robotology";
    repo = "ycm-cmake-modules";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZizhvKKTOpkpjgIbh0JJSBwCh46UZxccjrqg3J1ObTg=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Collection of various useful CMake modules";
    homepage = "https://robotology.github.io/ycm-cmake-modules/gh-pages/latest/index.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
