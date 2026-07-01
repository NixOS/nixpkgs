{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  installShellFiles,

  # build-system
  setuptools,

  # dependencies
  bitstring,
  click,
  cryptography,
  intelhex,
  pyserial,
  pyyaml,
  reedsolo,
  rich-click,
  softhsm,
  python-pkcs11,

  # check inputs
  pyelftools,
  pytestCheckHook,
  requests,
  pytest-rerunfailures,
}:

buildPythonPackage (finalAttrs: {
  pname = "esptool";
  version = "5.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NRfXLf8u35/9RD1QxEuV06K3h030qXj5GM+QjvLC6FM=";
  };

  postPatch = ''
    patchShebangs ci

    substituteInPlace test/test_espsecure_hsm.py \
      --replace-fail "/usr/lib/softhsm" "${lib.getLib softhsm}/lib/softhsm"
  '';

  __structuredAttrs = true;

  build-system = [
    setuptools
  ];

  dependencies = [
    bitstring
    click
    cryptography
    intelhex
    pyserial
    pyyaml
    reedsolo
    rich-click
  ];

  optional-dependencies = {
    hsm = [ python-pkcs11 ];
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    rm -v $out/bin/*.py
  ''
  +
    lib.strings.concatMapStrings
      (
        cmd:
        # Unfortunately, espsecure and espefuse do not run in cross-compilation
        lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform || cmd == "esptool") ''
          installShellCompletion --cmd ${cmd} \
            --bash <(_${lib.toUpper cmd}_COMPLETE=bash_source $out/bin/${cmd}) \
            --zsh <(_${lib.toUpper cmd}_COMPLETE=zsh_source $out/bin/${cmd}) \
            --fish <(_${lib.toUpper cmd}_COMPLETE=fish_source $out/bin/${cmd})
        ''
      )
      [
        "esptool"
        "espsecure"
        "espefuse"
        "esp_rfc2217_server"
      ];

  pythonImportsCheck = [
    "esptool"
    "espefuse"
    "espsecure"
    "esp_rfc2217_server"
  ];

  nativeCheckInputs = [
    pyelftools
    pytestCheckHook
    pytest-rerunfailures
    requests
    softhsm
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  pytestFlags = [
    "-m"
    "host_test"
  ];

  disabledTests = [
    # remove the deprecated .py entrypoints, because our wrapper tries to
    # import esptool and finds esptool.py in $out/bin, which breaks.
    "test_esptool_py"
    "test_espefuse_py"
    "test_espsecure_py"
    "test_esp_rfc2217_server_py"
  ];

  postCheck = ''
    export SOFTHSM2_CONF=$(mktemp)
    echo "directories.tokendir = $(mktemp -d)" > "$SOFTHSM2_CONF"
    ./ci/setup_softhsm2.sh

    pytest test/test_espsecure_hsm.py
  '';

  meta = {
    changelog = "https://github.com/espressif/esptool/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "ESP8266 and ESP32 serial bootloader utility";
    homepage = "https://github.com/espressif/esptool";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      dotlambda
      tmarkus
    ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "esptool";
  };
})
