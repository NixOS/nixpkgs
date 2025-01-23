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
  version = "0.2.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/deviceinfo";
    rev = finalAttrs.version;
    hash = "sha256-wTl+GgNiWzJxGLdU2iMH94UhQ40gjAPTVErouQIGXOA=";
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
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    mainProgram = "device-info";
    pkgConfigModules = [
      "deviceinfo"
    ];
  };
})
