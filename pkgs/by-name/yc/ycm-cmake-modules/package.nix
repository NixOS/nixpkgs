{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "ycm-cmake-modules";
  version = "0.18.4";
  src = fetchFromGitHub {
    owner = "robotology";
    repo = "ycm-cmake-modules";
    rev = "v${version}";
    hash = "sha256-Xmc23r3hmwg9v620KGfUV/s7feJUVVZD1OaT3TAQBBY=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Collection of various useful CMake modules";
    homepage = "https://robotology.github.io/ycm-cmake-modules/gh-pages/latest/index.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
