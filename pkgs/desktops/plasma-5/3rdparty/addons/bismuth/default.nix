{ lib
, mkDerivation
, fetchFromGitHub
, kcoreaddons
, kwindowsystem
, plasma-framework
, systemsettings
, cmake
, extra-cmake-modules
, esbuild
}:

mkDerivation rec {
  pname = "bismuth";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "Bismuth-Forge";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IWwFsYqoqW3924+pf8L+acIt31aU/mhqakXbT9Q4Bqw=";
  };

  cmakeFlags = [
    "-DUSE_TSC=OFF"
    "-DUSE_NPM=OFF"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    esbuild
  ];

  buildInputs = [
    kcoreaddons
    kwindowsystem
    plasma-framework
    systemsettings
  ];

  meta = with lib; {
    description = "A dynamic tiling extension for KWin";
    license = licenses.mit;
    maintainers = with maintainers; [ pasqui23 ];
    homepage = "https://bismuth-forge.github.io/bismuth/";
    inherit (kwindowsystem.meta) platforms;
  };
}
