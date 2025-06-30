{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "xdg-utils-cxx";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "azubieta";
    repo = "xdg-utils-cxx";
    rev = "v${version}";
    hash = "sha256-hEN0xqZUNfMOIrw3q+x4kEFhYoqmyn7W3f2w8AGw2wI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Implementation of the FreeDesktop specifications to be used in c++ projects";
    homepage = "https://github.com/azubieta/xdg-utils-cxx";
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
    mainProgram = "xdg-utils-cxx";
    platforms = platforms.linux;
  };
}
