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
}:

let
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
    (lib.cmakeFeature "TOMLPP_DIR" "${tomlplusplus}")
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
