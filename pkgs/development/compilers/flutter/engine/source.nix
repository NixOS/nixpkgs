{
  lib,
  callPackage,
  curlMinimal,
  pkg-config,
  gitMinimal,
  python312,
  runCommand,
  writeText,
  cacert,
  flutterVersion,
  version,
  hashes,
  url,
  hostPlatform,
  targetPlatform,
  buildPlatform,
  ...
}@pkgs:
let
  target-constants = callPackage ./constants.nix { platform = targetPlatform; };
  build-constants = callPackage ./constants.nix { platform = buildPlatform; };
  tools = pkgs.tools or (callPackage ./tools.nix { inherit hostPlatform buildPlatform; });

  boolOption = value: if value then "True" else "False";

  gclient = writeText "flutter-${version}.gclient" ''
    solutions = [{
      "managed": False,
      "name": ".",
      "url": "${url}",
      "custom_vars": {
        "download_fuchsia_deps": False,
        "download_android_deps": False,
        "download_linux_deps": ${boolOption targetPlatform.isLinux},
        "setup_githooks": False,
        "download_esbuild": False,
        "download_dart_sdk": True,
        "host_cpu": "${build-constants.alt-arch}",
        "host_os": "${build-constants.alt-os}",
      },
    }]

    target_os_only = True
    target_os = [
      "${target-constants.alt-os}"
    ]

    target_cpu_only = True
    target_cpu = [
      "${target-constants.alt-arch}"
    ]
  '';
in
runCommand "flutter-engine-source-${version}-${buildPlatform.system}-${targetPlatform.system}"
  {
    pname = "flutter-engine-source";
    inherit version;

    nativeBuildInputs = [
      curlMinimal
      pkg-config
      gitMinimal
      tools.cipd
      (python312.withPackages (
        ps: with ps; [
          httplib2
          six
        ]
      ))
    ];

    env = {
      NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      DEPOT_TOOLS_UPDATE = "0";
      DEPOT_TOOLS_COLLECT_METRICS = "0";
      PYTHONDONTWRITEBYTECODE = "1";
    };

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash =
      (hashes."${buildPlatform.system}" or { })."${targetPlatform.system}"
        or (throw "Hash not set for ${targetPlatform.system} on ${buildPlatform.system}");
  }
  ''
    source ${../../../../build-support/fetchgit/deterministic-git}
    export -f clean_git
    export -f make_deterministic_repo

    mkdir --parents flutter
    cp ${gclient} flutter/.gclient
    cd flutter
    export PATH=$PATH:${tools.depot_tools}
    python3 ${tools.depot_tools}/gclient.py sync --no-history --shallow --nohooks -j $NIX_BUILD_CORES
    mv engine $out

    find $out -name '.git' -exec rm --recursive --force {} \; || true

    rm --recursive $out/src/flutter/{buildtools,prebuilts,third_party/swiftshader,third_party/gn/.versions,third_party/dart/tools/sdks/dart-sdk}
  ''
