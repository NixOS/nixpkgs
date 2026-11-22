{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  haskellPackages,
  supercollider-with-sc3-plugins,
  symlinkJoin,
  writeShellApplication,
  writeText,
}:

let
  version = haskellPackages.tidal.version;

  ghcWithTidal = haskellPackages.ghcWithPackages (haskellPackages': [
    haskellPackages'.tidal
  ]);

  tidalBoot = stdenvNoCC.mkDerivation {
    pname = "tidal-cycles-boot";
    inherit version;
    src = haskellPackages.tidal.src;

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      install -Dm644 BootTidal.hs "$out/share/tidal-cycles/BootTidal.hs"

      runHook postInstall
    '';
  };

  mkQuark =
    {
      pname,
      version,
      quarkName,
      src,
      dependencies ? [ ],
    }:
    stdenvNoCC.mkDerivation {
      inherit pname version src;

      dontConfigure = true;
      dontBuild = true;

      installPhase =
        let
          linkDependencies = lib.concatMapStringsSep "\n" (dependency: ''
            ln -s ${dependency}/quark/* "$out/quark/"
          '') dependencies;
        in
        ''
          runHook preInstall

          mkdir -p "$out/quark/${quarkName}"
          cp -R ./. "$out/quark/${quarkName}/"
          ${linkDependencies}

          printf '%s\n' \
            'Quarks.clear;' \
            "Quarks.install(\"$out\");" \
            'thisProcess.recompile();' \
            > "$out/install.scd"

          printf '%s\n' \
            'includePaths:' \
            "  - $out/quark" \
            'excludePaths:' \
            '  []' \
            'postInlineWarnings: false' \
            'excludeDefaultPaths: false' \
            > "$out/sclang_conf.yaml"

          runHook postInstall
        '';
    };

  dirt-samples = mkQuark {
    pname = "dirt-samples";
    version = "unstable-2023-10-27";
    quarkName = "Dirt-Samples";
    src = fetchFromGitHub {
      owner = "tidalcycles";
      repo = "dirt-samples";
      rev = "9a6dff8f9ec3cd55b287290cf04e01afa6b8f532";
      hash = "sha256-Mp8qBpsOvW9Zguv95Kv7EU6S3ICaF2aO02Wz6xGURtE=";
    };
  };

  vowel = mkQuark {
    pname = "vowel";
    version = "unstable-2022-01-04";
    quarkName = "Vowel";
    src = fetchFromGitHub {
      owner = "supercollider-quarks";
      repo = "vowel";
      rev = "ab59caa870201ecf2604b3efdd2196e21a8b5446";
      hash = "sha256-zfF6cvAGDNYWYsE8dOIo38b+dIymd17Pexg0HiPFbxM=";
    };
  };

  superdirt = mkQuark {
    pname = "superdirt";
    version = "unstable-2023-10-15";
    quarkName = "SuperDirt";
    src = fetchFromGitHub {
      owner = "musikinformatik";
      repo = "superdirt";
      rev = "c7f32998572984705d340e7c1b9ed9ad998a39b6";
      hash = "sha256-9qU9CHYAXbN1IE3xXDqGipuroifVaSVXj3c/cDfwM80=";
    };
    dependencies = [
      dirt-samples
      vowel
    ];
  };

  superdirtStartSc = writeText "superdirt-start.sc" "SuperDirt.start;";

  tidalCycles = writeShellApplication {
    name = "tidal-cycles";
    runtimeInputs = [ ghcWithTidal ];
    text = ''
      exec ghci -ghci-script "${tidalBoot}/share/tidal-cycles/BootTidal.hs" "$@"
    '';
  };

  sclangWithSuperDirt = writeShellApplication {
    name = "sclang-with-superdirt";
    runtimeInputs = [ supercollider-with-sc3-plugins ];
    text = ''
      exec sclang -l "${superdirt}/sclang_conf.yaml" "$@"
    '';
  };

  superdirtStart = writeShellApplication {
    name = "superdirt-start";
    text = ''
      start_script="''${1:-${superdirtStartSc}}"

      if [[ "$start_script" == "-h" || "$start_script" == "--help" ]]; then
        echo "Usage: superdirt-start [script]"
        echo
        echo "Start SuperDirt, optionally running a custom start script."
        echo
        echo "Options:"
        echo "  -h --help    Show this screen."
        exit 0
      fi

      if [[ ! -e "$start_script" ]]; then
        echo "The script \"$start_script\" does not exist, aborting." >&2
        exit 1
      fi

      exec ${sclangWithSuperDirt}/bin/sclang-with-superdirt "$start_script"
    '';
  };

  superdirtInstall = writeShellApplication {
    name = "superdirt-install";
    runtimeInputs = [ supercollider-with-sc3-plugins ];
    text = ''
      exec sclang "${superdirt}/install.scd"
    '';
  };
in
symlinkJoin {
  pname = "tidal-cycles-full";
  inherit version;

  paths = [
    tidalCycles
    sclangWithSuperDirt
    superdirtStart
    superdirtInstall
    supercollider-with-sc3-plugins
  ];

  passthru = {
    inherit
      dirt-samples
      ghcWithTidal
      superdirt
      superdirtStartSc
      tidalBoot
      vowel
      ;
  };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "TidalCycles live-coding environment with SuperDirt";
    longDescription = ''
      This package provides the TidalCycles live-coding environment and
      SuperDirt setup helpers. It installs the `tidal-cycles`,
      `sclang-with-superdirt`, `superdirt-start`, and `superdirt-install`
      commands, and also makes the wrapped SuperCollider programs from
      `supercollider-with-sc3-plugins` available.
    '';
    homepage = "https://tidalcycles.org/";
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
      gpl3Plus
    ];
    mainProgram = "tidal-cycles";
    maintainers = with lib.maintainers; [ crertel ];
    platforms = lib.platforms.linux;
  };
}
