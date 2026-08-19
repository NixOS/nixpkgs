{
  lib,
  stdenv,
  fetchFromGitea,
  nix-update-script,
  runCommand,

  # build-time
  bison,
  cmake,
  flex,
  openvaf,
  python3,

  # run-time
  boost188,
  suitesparse,
  tomlplusplus,

  # VACASK's device models are compiled by OpenVAF, a Verilog-A compiler.
  #
  # By default, OpenVAF's `--target_cpu native` tells it to use every CPU
  # instruction available on the machine doing the build (e.g. AVX-512, if the
  # builder happens to have it). If the resulting binary is then run on a
  # different, older CPU that doesn't support those instructions, it crashes
  # with "illegal instruction" (SIGILL).
  #
  # To avoid this, we detect which instruction set the CPU we're building for
  # actually supports and tell OpenVAF to target that instead, which keeps the
  # compiled models runnable on other x86_64 machines as well.
  #
  # See:
  #   - https://codeberg.org/arpadbuermen/VACASK/src/commit/bf59752fbfdfed18dc7fe2e3e11a9c02f8de28a0/README.md#installation-from-pre-built-packages
  #   - https://github.com/NixOS/nixpkgs/blob/dc36b3c506df17272cdca29e85d0d0190b068981/lib/systems/architectures.nix
  openvafTargetCpu ?
    with stdenv.hostPlatform;
    if isx86_64 then
      if avx512Support then
        "x86-64-v4"
      else if avx2Support then
        "x86-64-v3"
      else if sse4_2Support then
        "x86-64-v2"
      else
        "x86-64"
    else
      "generic",
}:

let
  # VACASK includes SuiteSparse headers as <suitesparse/klu.h>, the layout used
  # by SuiteSparse >= 6. However, our suitesparse is currently at 5.13.0 and
  # installs headers flat into include/, so here we're fixing that.
  # TODO: remove when suitesparse is updated
  suitesparse-include = runCommand "suitesparse-include" { } ''
    mkdir -p $out/include/suitesparse
    ln -s ${suitesparse.dev}/include/*.h $out/include/suitesparse/
  '';

  pyEnv = python3.withPackages (
    ps: with ps; [
      numpy
      scipy
    ]
  );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "vacask";
  version = "0.3.3";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "arpadbuermen";
    repo = "VACASK";
    tag = "_${finalAttrs.version}";
    hash = "sha256-eU3SuJPqxqc8QO5k4Jb/9zc8V2JQ1VP1bPEoJ6KCi/c=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "Boost_USE_STATIC_LIBS ON" \
        "Boost_USE_STATIC_LIBS OFF" \
      --replace-fail \
        'set(PROGRAM_VERSION "unknown")' \
        'set(PROGRAM_VERSION "${finalAttrs.version}")'
  '';

  nativeBuildInputs = [
    bison
    boost188.dev
    cmake
    flex
    openvaf
    pyEnv
  ];

  buildInputs = [
    boost188
    suitesparse
    tomlplusplus
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FLEX_INCLUDE_DIR" "${flex}/include")
    (lib.cmakeFeature "SuiteSparse_DIR" "${suitesparse-include}")
    (lib.cmakeFeature "TOMLPP_DIR" "${tomlplusplus}")
    (lib.cmakeFeature "OPENVAF_OPTIONS" "--target_cpu ${openvafTargetCpu}")
  ];

  doCheck = true;

  nativeCheckInputs = [
    openvaf
    pyEnv
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Analog circuit simulator";
    longDescription = ''
      VACASK is a Verilog-A Circuit Analysis Kernel - an analog circuit
      simulator with a device library built from Verilog-A modules.
    '';
    homepage = "https://codeberg.org/arpadbuermen/VACASK";
    changelog = "https://codeberg.org/arpadbuermen/VACASK/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "vacask";
    license = lib.licenses.agpl3Plus;
    # TODO: add darwin support
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
