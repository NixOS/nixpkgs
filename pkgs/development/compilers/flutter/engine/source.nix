{
  curlMinimal,
  gitMinimal,
  python312,
  depot_tools,
  runCommand,
  writeText,
  cacert,
  version,
  engineHash ? "",
  cipd,
  writableTmpDirAsHomeHook,
}:

let
  gclient = writeText ".gclient" ''
    solutions = [
      {
        "name": ".",
        "url": "https://github.com/flutter/flutter.git@${version}",
        "managed": False,
        "custom_vars": {
          "download_dart_sdk": False,
          "download_esbuild": False,
          "download_android_deps": False,
          "download_jdk": False,
          "download_linux_deps": False,
          "download_windows_deps": False,
          "download_fuchsia_deps": False,
          "checkout_llvm": False,
          "setup_githooks": False,
          "release_candidate": True,
        },
      }
    ]
    target_os = [ "linux" ]
    target_cpu = [ "x64", "arm64", "riscv64" ]
    target_os_only = True
    target_cpu_only = True
  '';
in
runCommand "flutter-engine-source-${version}"
  {
    pname = "flutter-engine-source";
    inherit version;

    nativeBuildInputs = [
      curlMinimal
      gitMinimal
      cipd
      (python312.withPackages (
        ps: with ps; [
          httplib2
          six
        ]
      ))
      writableTmpDirAsHomeHook
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
    outputHash = engineHash;
  }
  ''
    mkdir --parents source
    cd source
    cp ${gclient} .gclient
    export PATH=$PATH:${depot_tools}
    python3 ${depot_tools}/gclient.py sync --no-history --shallow --nohooks --jobs=$NIX_BUILD_CORES
    rm --recursive --force engine/src/flutter/buildtools engine/src/flutter/third_party/dart/tools/sdks/dart-sdk engine/src/flutter/third_party/gn third_party/ninja
    rm --recursive --force engine/src/flutter/third_party/swiftshader/.git
    rm --recursive --force engine/src/flutter/third_party/swiftshader/tests
    rm --recursive --force engine/src/flutter/third_party/swiftshader/docs
    rm --recursive --force engine/src/flutter/third_party/swiftshader/infra
    rm --recursive --force engine/src/flutter/third_party/swiftshader/.vscode
    rm --recursive --force engine/src/flutter/third_party/swiftshader/llvm-16.0
    rm --recursive --force engine/src/flutter/third_party/swiftshader/llvm-10.0
    rm --recursive --force engine/src/flutter/third_party/llvm-project
    find engine/src/flutter/third_party/swiftshader/third_party -type d \( -name "test" -o -name "tests" -o -name "unittests" \) -prune -exec rm --recursive --force {} +
    find engine/src/flutter/third_party/swiftshader -type f \( -name "*.o" -o -name "*.a" -o -name "*.so" \) -delete
    find . -type d \( -name ".git" -o -name ".cipd" \) -prune -exec rm --recursive --force {} +
    find . -type f -name ".gclient*" -delete
    cp --recursive . $out
  ''
