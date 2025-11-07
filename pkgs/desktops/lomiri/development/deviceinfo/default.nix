{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  cmake,
  pkg-config,
  cmake-extras,
  gtest,
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deviceinfo";
  version = "0.2.4";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/deviceinfo";
    rev = finalAttrs.version;
    hash = "sha256-eZQyTRhMRobufPk5AcTY8G718T+/e3teFtqV5kGspxw=";
  };

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  postPatch = ''
    # For our automatic pkg-config output patcher to work, prefix must be used here
    substituteInPlace headers/deviceinfo.pc.in \
      --replace-fail 'libdir=''${exec_prefix}' 'libdir=''${prefix}'
  '';

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
    "-DDISABLE_TESTS=${lib.boolToString (!finalAttrs.finalPackage.doCheck)}"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Library to detect and configure devices";
    homepage = "https://gitlab.com/ubports/development/core/deviceinfo";
    changelog = "https://gitlab.com/ubports/development/core/deviceinfo/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl3Only;
    teams = [ teams.lomiri ];
    platforms = platforms.linux;
    mainProgram = "device-info";
    pkgConfigModules = [
      "deviceinfo"
    ];
  };
})
