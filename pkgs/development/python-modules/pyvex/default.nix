{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  scikit-build-core,

  bitstring,
  buildPackages,
  cffi,
  pycparser,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyvex";
  version = "9.2.212";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pyvex";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-0A4HdeuXo7YL392hPCV7SRxW7Vje1SUs7vaxawFbUPg=";
  };

  build-system = [
    cmake
    ninja
    scikit-build-core
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    bitstring
    cffi
    pycparser
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ cffi ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace vex/Makefile-gcc \
      --replace-fail '/usr/bin/ar' 'ar'
  '';

  setupPyBuildFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "--plat-name"
    "linux"
  ];

  preBuild = ''
    export CC=${stdenv.cc.targetPrefix}cc
    # substituteInPlace pyvex_c/Makefile \
    #   --replace-fail 'AR=ar' 'AR=${stdenv.cc.targetPrefix}ar'
  '';

  # No tests are available on PyPI, GitHub release has tests
  # Switch to GitHub release after all angr parts are present
  doCheck = false;

  pythonImportsCheck = [ "pyvex" ];

  meta = {
    description = "Python interface to libVEX and VEX IR";
    homepage = "https://github.com/angr/pyvex";
    license = with lib.licenses; [
      bsd2
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
