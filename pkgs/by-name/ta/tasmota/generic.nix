{
  coreutils,
  fetchFromGitHub,
  fetchzip,
  jq,
  lib,
  nix,
  platformio,
  python3,
  runCommand,
  stdenv,
  writers,

  # tasmota flavor
  flavor ? "tasmota",
  flavors, # needed, because some flavors depend on others
  # enabling ipv6 support via this flag only affects flavors prefixed with 'tasmota-'
  # 'tasmote32-' flavors already have ipv6 support enabled
  withIPv6 ? false,
  buildFlags ? [ ],
}:
let
  hashes = lib.importJSON ./hashes.json;
  # extract prefix of flave, like 'tasmote32s3' in 'tasmote32s3-webcam'
  flavorPrefix =
    let
      match = lib.match "(.*)-.*" flavor;
    in
    if match == null then flavor else lib.head match;
  sources = {
    platforms = lib.flip lib.mapAttrs hashes.platforms (
      name: hash: fetchzip { inherit (hashes.platforms.${name}) hash url; }
    );
    packages = lib.flip lib.mapAttrs hashes.packages (
      name: hash:
      fetchzip (
        {
          inherit (hashes.packages.${name}) hash url;
        }
        // {
          tool-esptoolpy.stripRoot = false;
          toolchain-riscv32-esp.stripRoot = false;
          toolchain-xtensa.stripRoot = false;
          toolchain-xtensa-esp-elf.stripRoot = false;
          tool-mklittlefs.stripRoot = false;
          tool-riscv32-esp-elf-gdb.stripRoot = false;
          tool-scons.stripRoot = false;
          tool-xtensa-esp-elf-gdb.stripRoot = false;
        }
        .${name} or { }
      )
    );
  };
  platformioDir = runCommand "platformio-dir" { } ''
    mkdir -p $out/{packages,platforms}
    ${lib.concatMapStringsSep "\n" (name: ''
      cp -r ${sources.platforms.${name}} $out/platforms/${name}
    '') (lib.attrNames sources.platforms)}
    ${lib.concatMapStringsSep "\n" (name: ''
      cp -r ${sources.packages.${name}} $out/packages/${name}
    '') (lib.attrNames sources.packages)}
    chmod +w -R $out
    # vendor .piopm files
    for platform in $out/platforms/*/; do
      cp ${./.platformio}/platforms/$(basename $platform)/.piopm $out/platforms/$(basename $platform)/
    done
    for package in $out/packages/*/; do
      cp ${./.platformio}/packages/$(basename $package)/.piopm $out/packages/$(basename $package)/
    done
  '';
in
stdenv.mkDerivation (finalAttrs: {
  name = "tasmota-${flavor}";
  version = "14.4.1";
  src = fetchFromGitHub {
    owner = "arendst";
    repo = "Tasmota";
    rev = "v${finalAttrs.version}";
    # TODO: platformio needs update before we can build 14.0.0
    sha256 = "sha256-xfGWDyWNmuYFPisx1fkLJSrb6ZIouG7DGWNTqWCY2oo="; # 14.4.1
  };
  nativeBuildInputs = [
    jq
    platformio
    python3
    python3.pkgs.tasmota-metrics
    python3.pkgs.pyyaml
  ];
  PLATFORMIO_BUILD_FLAGS = lib.concatStringsSep " " (
    buildFlags
    ++ lib.optionals withIPv6 [
      "-DUSE_IPV6"
      "-DPIO_FRAMEWORK_ARDUINO_LWIP2_IPV6_HIGHER_BANDWIDTH"
    ]
  );
  buildPhase = ''
    echo "populating ./.platformio directory"
    cp -r ${platformioDir} ./.platformio
    chmod -R +w ./.platformio

    # tasmota for esp8266 wants a different esptoolpy version,
    # let's patch that requirement to match the version that we fetched
    cat ./.platformio/platforms/espressif8266/platform.json \
      | jq '.packages."tool-esptoolpy".version = "${hashes.packages.tool-esptoolpy.url}"' \
      > ./.platformio/platforms/espressif8266/platform.json.tmp
    mv ./.platformio/platforms/espressif8266/{platform.json.tmp,platform.json}

    export PLATFORMIO_CORE_DIR=$(realpath ./.platformio)
    mkdir -p variants/tasmota
    ${
      # some flavors depend on their own safeboot variant
      #   see: https://tasmota.github.io/docs/Safeboot/
      # if there is a safeboot variant for the current flavor, build it first
      if !lib.hasSuffix "-safeboot" flavor && flavors ? "${flavorPrefix}-safeboot" then
        ''
          cp ${flavors."${flavorPrefix}-safeboot"}/* variants/tasmota/
        ''
      else
        ""
    }
    platformio run -e ${flavor}
  '';
  installPhase = ''
    mkdir $out
    mv build_output/firmware/* $out/
  '';
  passthru.updateScript = writers.writePython3 "update-tasmota.py" {
    makeWrapperArgs = [
      "--set"
      "PATH"
      (lib.makeBinPath ([
        coreutils
        nix
        platformio
      ]))
    ];
  } ./update.py;
  passthru.flavors = flavors;
  meta = {
    description = "Open source firmware for ESP devices";
    longDescription = "Alternative firmware for ESP8266 and ESP32 based devices with easy configuration using webUI, OTA updates, automation using timers or rules, expandability and entirely local control over MQTT, HTTP, Serial or KNX";
    homepage = "https://tasmota.github.io/docs/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ davhau ];
    platforms = [ "x86_64-linux" ];
  };
})
