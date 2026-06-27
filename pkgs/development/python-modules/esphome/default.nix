{
  lib,
  stdenv,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  installShellFiles,
  git,
  versionCheckHook,
  nixosTests,

  # dependencies
  aioesphomeapi,
  argcomplete,
  bleak,
  cairosvg,
  click,
  colorama,
  cryptography,
  esphome-glyphsets,
  esptool,
  freetype-py,
  icmplib,
  jinja2,
  paho-mqtt,
  pillow,
  platformio,
  platformio-core,
  puremagic,
  py7zr,
  pyparsing,
  pyserial,
  pyyaml,
  requests,
  resvg-py,
  ruamel-yaml,
  smpclient,
  tornado,
  tzdata,
  tzlocal,
  voluptuous,
  zeroconf,

  # check inputs
  hypothesis,
  mock,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,

  # build-system
  setuptools,

  python,
}:

let
  # NOTE 2026-06-25: Legacy dashboard will be removed in next major release after 2026.6.x
  esphome-dashboard = callPackage ./dashboard.nix { };

  paho-mqtt' = paho-mqtt.overridePythonAttrs (oldAttrs: rec {
    version = "1.6.1";
    src = fetchFromGitHub {
      inherit (oldAttrs.src) owner repo;
      tag = "v${version}";
      hash = "sha256-9nH6xROVpmI+iTKXfwv2Ar1PAmWbEunI3HO0pZyK6Rg=";
    };
    build-system = [ setuptools ];
    doCheck = false;
  });
in

buildPythonPackage (finalAttrs: {
  pname = "esphome";
  version = "2026.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "esphome";
    tag = finalAttrs.version;
    hash = "sha256-h7aMPSXmIUutCGMoZlE3Z1wX2xNxdmZsHfBllcFHBHc=";
  };

  patches = [
    # Use the esptool executable directly in the ESP32 post build script, that
    # gets executed by platformio. This is required, because platformio uses its
    # own python environment through `python -m esptool` and then fails to find
    # the esptool library.
    ./esp32-post-build-esptool-reference.patch
    # Call the platformio binary directly instead of `python -m
    # esphome.platformio_runner`, which tries to import platformio as a Python
    # module.
    ./platformio-binary-reference.patch
  ];

  # our Python version needs to match the one used in the platformio-core override
  disabled = python.pythonVersion != platformio-core.python.pythonVersion;

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    installShellFiles
    argcomplete
  ];

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    "esptool"
    "platformio"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==82.0.1" "setuptools" \
      --replace-fail "wheel>=0.43,<0.48" "wheel"
  '';

  # Remove esptool and platformio from requirements
  env.ESPHOME_USE_SUBPROCESS = "";

  dependencies = [
    aioesphomeapi
    argcomplete
    bleak
    cairosvg
    click
    colorama
    cryptography
    esphome-dashboard
    esphome-glyphsets
    freetype-py
    icmplib
    jinja2
    paho-mqtt'
    pillow
    platformio
    puremagic
    py7zr
    pyparsing
    pyserial
    pyyaml
    requests
    resvg-py
    ruamel-yaml
    smpclient
    tornado
    tzdata
    tzlocal
    voluptuous
    zeroconf
  ];

  makeWrapperArgs = [
    # platformio is used in esphome/platformio_api.py
    # esptool is used in esphome/__main__.py
    # git is used in esphome/git.py
    "--prefix PATH : ${
      lib.makeBinPath [
        platformio
        esptool
        git
      ]
    }"
    # The dashboard requires esphome to be importable
    # dependencies are added to show better error messages
    "--prefix PYTHONPATH : $out/${python.sitePackages}:${python.pkgs.makePythonPath finalAttrs.passthru.dependencies}"
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc ]}"
    "--set ESPHOME_USE_SUBPROCESS ''"
    # https://github.com/NixOS/nixpkgs/issues/362193
    "--set PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION 'python'"
  ];

  # Needed for tests
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    hypothesis
    mock
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    git
    versionCheckHook
  ];

  disabledTestPaths = [
    # platformio builds; requires networking for dependency resolution
    "tests/integration"

    # tries to dynamically patch platformio module
    "tests/unit_tests/test_writer.py"
    "tests/unit_tests/test_espidf_component.py"
  ];

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  postInstall =
    let
      register-python-argcomplete = lib.getExe' argcomplete "register-python-argcomplete";
    in
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd esphome \
        --bash <(${register-python-argcomplete} -s bash $out/bin/esphome) \
        --fish <(${register-python-argcomplete} -s fish $out/bin/esphome) \
        --zsh <(${register-python-argcomplete} -s zsh $out/bin/esphome)
    '';

  doInstallCheck = true;

  disabledTests = [
    # tries to import platformio, which is wrapped in an fhsenv
    "test_clean_build"
    "test_clean_build_empty_cache_dir"
    "test_clean_all"
    "test_clean_all_partial_exists"
    # tries to use esptool, which is wrapped in an fhsenv
    "test_upload_using_esptool_passes_crystal_callback"
    "test_upload_using_esptool_path_conversion"
    "test_upload_using_esptool_skips_missing_extra_flash_images"
    "test_upload_using_esptool_with_file_path"
    # AssertionError: Expected 'run_external_command' to have been called once. Called 0 times.
    "test_run_platformio_cli_sets_environment_variables"
    # Expects a full git clone
    "test_clang_tidy_mode_full_scan"
    "test_clang_tidy_mode_targeted_scan"
    # Patched to run platformio without the esphome wrapper
    "test_run_platformio_cli_strips_win_long_path_prefix"
    "test_run_platformio_cli_does_not_set_pythonexepath_without_strip"
    "test_patch_file_downloader_recovers_against_real_server"
  ];

  pythonImportsCheck = [
    "esphome"
  ];

  passthru = {
    dashboard = esphome-dashboard;
    updateScript = callPackage ./update.nix { };
    tests = { inherit (nixosTests) esphome; };
  };

  meta = {
    changelog = "https://github.com/esphome/esphome/releases/tag/${finalAttrs.src.tag}";
    description = "Make creating custom firmwares for ESP32/ESP8266 super easy";
    homepage = "https://esphome.io/";
    license = with lib.licenses; [
      mit # The C++/runtime codebase of the ESPHome project (file extensions .c, .cpp, .h, .hpp, .tcc, .ino)
      gpl3Only # The python codebase and all other parts of this codebase
    ];
    maintainers = with lib.maintainers; [
      hexa
      picnoir
      thanegill
      karlbeecken
      tmarkus
    ];
    mainProgram = "esphome";
  };
})
