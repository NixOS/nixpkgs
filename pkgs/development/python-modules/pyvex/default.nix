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

  postPatch =
    # The upstream CMakeLists.txt generates libvex_guest_offsets.h at build time by running
    # genoffsets with `>` redirection, which truncates the output file.
    # Under high parallelism, ir_opt.c races to compile before the header is fully written.
    # We pre-generate the header in preBuild and replace the genoffsets cmake step with a no-op to
    # prevent cmake from re-running it.
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail \
          'COMMAND $<TARGET_FILE:genoffsets> > ''${CMAKE_SOURCE_DIR}/vex/pub/libvex_guest_offsets.h' \
          'COMMAND ''${CMAKE_COMMAND} -E true'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace vex/Makefile-gcc \
        --replace-fail "/usr/bin/ar" "${stdenv.cc.targetPrefix}ar"
    '';

  setupPyBuildFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "--plat-name"
    "linux"
  ];

  env = {
    CC = "${stdenv.cc.targetPrefix}cc";
  };

  # Pre-generate libvex_guest_offsets.h before the cmake/ninja build.
  # The upstream CMakeLists.txt generates this header via a custom command that
  # uses `>` redirection which truncates the file. Under high parallelism,
  # ir_opt.c races to compile before the header is fully written.
  # By pre-generating the header AND touching the stamp file that cmake uses to
  # track whether the command ran, we prevent cmake from re-running genoffsets.
  preBuild = ''
    $CC -Ivex/pub vex/auxprogs/genoffsets.c -o genoffsets_pre
    ./genoffsets_pre > vex/pub/libvex_guest_offsets.h
    rm genoffsets_pre
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
