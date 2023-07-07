{ stdenv
, lib
, fetchFromGitLab
, gitUpdater
, testers
, cmake
, pkg-config
, cmake-extras
, gtest
, yaml-cpp
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deviceinfo";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/deviceinfo";
    rev = finalAttrs.version;
    hash = "sha256-oKuX9JbYWIjroKgA2Y+/oqPkC26DPy3e6yHFU8mmbxQ=";
  };

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cmake-extras
    yaml-cpp
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    "-DDISABLE_TESTS=${lib.boolToString (!finalAttrs.doCheck)}"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Library to detect and configure devices";
    homepage = "https://gitlab.com/ubports/development/core/deviceinfo";
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    mainProgram = "device-info";
    pkgConfigModules = [
      "deviceinfo"
    ];
  };
})
