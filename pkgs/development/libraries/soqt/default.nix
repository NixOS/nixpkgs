{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  coin3d,
  qtbase,
  testers,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soqt";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "soqt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H904mFfrELjB6ZVhypaKJd+pu5y+aVV4foryrsN7IqE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    coin3d
    qtbase
  ];

  dontWrapQtApps = true;

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "soqt" ];
      package = finalAttrs.finalPackage;
      nativeBuildInputs = [ wrapQtAppsHook ];
    };
  };

  meta = {
    homepage = "https://github.com/coin3d/soqt";
    license = lib.licenses.bsd3;
    description = "Glue between Coin high-level 3D visualization library and Qt";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})
