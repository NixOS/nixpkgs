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
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Bismuth-Forge";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ICpGgFvVi7tiYbMCo3JWQmbA36rdWF4NFYTWIejhxr4=";
  };

  patches = [
    ./0001-Avoid-usage-of-npx.patch
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
