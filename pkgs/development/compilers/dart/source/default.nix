{
  buildPackages,
  callPackage,
  cacert,
  curlMinimal,
  dart-bin,
  debug ? false,
  fetchurl,
  fetchpatch,
  gitMinimal,
  gitSetupHook,
  icu,
  jq,
  lib,
  nix-update,
  pax-utils,
  pkg-config,
  python3,
  ripgrep,
  stdenv,
  writableTmpDirAsHomeHook,
  writeShellScript,
  writeText,
  zlib,
}:

let
  version = "3.13.0";

  tools = callPackage ../../flutter/engine/tools.nix { inherit (stdenv) hostPlatform buildPlatform; };

  getArchInfo =
    platform:
    let
      arch = if platform.isx86_64 then "x64" else platform.linuxArch;
    in
    {
      inherit arch;
      outSuffix = lib.strings.toUpper arch;
    };

  targetArchInfo = getArchInfo stdenv.hostPlatform;

  buildArchInfo = getArchInfo stdenv.buildPlatform;

  pythonEnv = python3.withPackages (
    ps: with ps; [
      httplib2
      six
    ]
  );

  src = stdenv.mkDerivation (finalAttrs: {
    pname = "dart-source-deps";
    inherit version;

    nativeBuildInputs = [
      cacert
      curlMinimal
      tools.cipd
      gitMinimal
      pax-utils
      python3
      writableTmpDirAsHomeHook
    ];

    env = {
      NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      DEPOT_TOOLS_UPDATE = "0";
      DEPOT_TOOLS_COLLECT_METRICS = "0";
      PYTHONDONTWRITEBYTECODE = "1";
      CIPD_HTTP_USER_AGENT = "standard-nix-build";
    };

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-kw6bygtcy+yAPLX61CYzcA9l0GRZaI70hB5oY0xJEjU=";

    buildCommand = ''
      mkdir source
      cd source
      cp ${writeText ".gclient" ''
        solutions = [{
            'name': 'sdk',
            'url': 'https://dart.googlesource.com/sdk.git@${finalAttrs.version}',
        }]
        target_os = ['linux']
        target_cpu = ['x64', 'arm64', 'riscv64']
        target_cpu_only = True
      ''} .gclient
      export PATH=${pythonEnv}/bin:$PATH:${tools.depot_tools}
      python3 ${tools.depot_tools}/gclient.py sync --no-history --nohooks --noprehooks
      find sdk -name ".versions" -type d -exec rm -rf {} +
      rm --recursive --force sdk/buildtools/sysroot
      rm --recursive --force sdk/buildtools/linux-arm64
      rm --recursive --force sdk/buildtools/reclient
      rm --recursive --force sdk/buildtools/*/clang
      find sdk -type f \( -name "*.snapshot" -o -name "*.dill" -o -name "*.sym" \) -delete
      rm --recursive --force sdk/tools/sdks/dart-sdk
      find . -type l ! -exec test -e {} \; -delete
      find . -name "ChangeLog*" -delete
      rm --force .gclient .gclient_entries .gclient_previous_sync_commits .last_sync_hashes
      rm --recursive --force .cipd .cipd_cache
      find . -name ".git" -type d -prune -exec rm --recursive --force {} +
      find . -name ".git*" -exec rm --recursive --force {} +
      find . \( \
          -name ".build-id" -o \
          -name ".svn" -o \
          -name "*~" -o \
          -name "#*#" \
      \) -exec rm --recursive --force {} +
      for elf in $(scanelf --recursive --all --format "%F" sdk | sort); do
          rm --force "$elf"
      done
      find . -name "__pycache__" -type d -exec rm --recursive --force {} +
      find . -name "*.pyc" -delete
      cp --recursive sdk $out
    '';
  });
in
dart-bin.overrideAttrs (oldAttrs: {
  inherit version src;

  nativeBuildInputs = [
    gitMinimal
    gitSetupHook
    python3
    ripgrep
    pkg-config
  ];

  buildInputs = lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
    icu
    zlib
  ];

  patches = [
    ./gcc13.patch
    ./zlib-not-found.patch
    ./custom-flags.patch

    # Remove when upgrading to Dart 3.14:
    (fetchpatch {
      name = "dart-ignore-binaryen-warnings.patch";
      url = "https://github.com/dart-lang/sdk/commit/963b46dfebad01cab9e063fc8b508df227154a31.patch";
      hash = "sha256-+JY97WFq+UWNoGikXfHIPxBwPdCWV1HYHjhi9pzqVCo=";
    })
  ]
  ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
    ./unbundle-icu.patch
  ];

  postPatch = ''
    sed --in-place '/"-fsanitize=memory"/d' build/config/compiler/BUILD.gn
    patchShebangs runtime/tools/
    sed --in-place 's/ldflags = pkgresult\[4\]/ldflags = []/' build/config/linux/pkg_config.gni
    cp ${
      fetchurl {
        url = "https://raw.githubusercontent.com/chromium/chromium/631a813125b886a52274653144019fd1681a0e97/build/config/linux/pkg-config.py";
        hash = "sha256-9coRpgCewlkFXSGrMVkudaZUll0IFc9jDRBP+2PloOI=";
      }
    } build/config/linux/pkg-config.py
  ''
  + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    sed --in-place "s/default='pkg-config'/default='${stdenv.cc.targetPrefix}pkg-config'/g" build/config/linux/pkg-config.py
    mkdir --parents .bin-tools
    ln --symbolic $(command -v ${buildPackages.stdenv.cc.targetPrefix}g++) .bin-tools/${stdenv.buildPlatform.parsed.cpu.name}-linux-gnu-g++
    ln --symbolic $(command -v ${buildPackages.stdenv.cc.targetPrefix}gcc) .bin-tools/${stdenv.buildPlatform.parsed.cpu.name}-linux-gnu-gcc
    ln --symbolic $(command -v ${buildPackages.stdenv.cc.targetPrefix}ar) .bin-tools/${stdenv.buildPlatform.parsed.cpu.name}-linux-gnu-ar
    export PATH=$PWD/.bin-tools:$PATH
  ''
  + ''
    ln --symbolic ${buildPackages.dart-bin} tools/sdks/dart-sdk
    ln --symbolic --force ${lib.getExe buildPackages.gn} buildtools/gn
    mkdir --parents buildtools/ninja
    ln --symbolic --force ${lib.getExe buildPackages.samurai} buildtools/ninja/ninja
    python3 tools/generate_package_config.py
    python3 tools/generate_sdk_version_file.py
    echo "" > tools/bots/dartdoc_footer.html
    JOBS_COUNT=''${NIX_BUILD_CORES:-2}
    rg --no-ignore -l 'google-analytics\.com' . \
      | rg -v "\.map\$" \
      | xargs --no-run-if-empty -t -n 1 -P "$JOBS_COUNT" \
        sed --in-place --regexp-extended 's|([^/]+\.)?google-analytics\.com|0\.0\.0\.0|g'
    rg --no-ignore -l 'UA-[0-9]+-[0-9]+' . \
      | xargs --no-run-if-empty -t -n 1 -P "$JOBS_COUNT" \
        sed --in-place --regexp-extended 's|UA-[0-9]+-[0-9]+|UA-2137-0|g'
  ''
  + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    install -D --mode=0644 ${./unbundle/icu.gn} build/linux/unbundle/icu.gn
    install -D --mode=0644 ${./unbundle/zlib.gn} build/linux/unbundle/zlib.gn
    install -D --mode=0755 ${./unbundle/replace_gn_files.py} build/linux/unbundle/replace_gn_files.py
    install -D --mode=0644 ${./unbundle/shim_headers.gni} build/shim_headers.gni
    install -D --mode=0644 ${
      fetchurl {
        url = "https://raw.githubusercontent.com/dart-lang/sdk/d684a576a6aa954ae107a03b2b4e1d61c3bebe93/tools/generate_shim_headers.py";
        hash = "sha256-jE3RZFnqq0mUR7tIrTGU5sblBaBsi/SwhKg2H37ypGg=";
      }
    } tools/generate_shim_headers.py

    for _lib in icu zlib; do
        find . -type f -path "*third_party/$_lib/*" \
            \! -path "*third_party/$_lib/chromium/*" \
            \! -path "*third_party/$_lib/google/*" \
            \! -regex '.*\.\(gn\|gni\|isolate\|py\)' \
            -delete
    done
    python3 build/linux/unbundle/replace_gn_files.py --system-libraries icu zlib
  ''
  + ''
    git init
    git add .
    git commit --message="stub" --quiet
  '';

  buildPhase = ''
    runHook preBuild

    python3 ./tools/build.py \
      --no-clang \
      --mode=${if debug then "debug" else "release"} \
      --arch=${targetArchInfo.arch} \
      --gn-args="${targetArchInfo.arch}_toolchain_prefix=\"${stdenv.cc}/bin/${stdenv.cc.targetPrefix}\"" \
  ''
  + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    --gn-args="dart_target_arch=\"${targetArchInfo.arch}\"" \
    --gn-args="dart_host_arch=\"${buildArchInfo.arch}\"" \
    --gn-args="${buildArchInfo.arch}_toolchain_prefix=\"${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}\"" \
    --gn-args="host_cpu=\"${buildArchInfo.arch}\"" \
    --gn-args="dart_force_runtime_snapshot_deps=true" \
    --gn-args="host_toolchain_prefix=\"${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}\"" \
    --gn-args="target_cpu=\"${targetArchInfo.arch}\"" \
  ''
  + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    --gn-args="dart_embed_icu_data=false dart_snapshot_kind=\"app-jit\"" \
  ''
  + ''
      --gn-args="dart_sysroot=\"\"" \
      --no-verify-sdk-hash \
      create_sdk runtime

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pushd out/${if debug then "Debug" else "Release"}${
      if (stdenv.hostPlatform == stdenv.buildPlatform) then targetArchInfo.outSuffix else "*"
    }/dart-sdk
    rm LICENSE README revision
    cp --recursive . $out
    popd

    runHook postInstall
  '';

  passthru = oldAttrs.passthru // {
    updateScript = writeShellScript "update-dart" ''
      ${lib.getExe nix-update} --version=$(${lib.getExe curlMinimal} --fail --location --silent https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION | ${lib.getExe jq} --raw-output .version)
    '';
  };

  meta = oldAttrs.meta // {
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
