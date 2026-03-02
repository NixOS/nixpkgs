{
  bazel_7,
  buildBazelPackage,
  curl,
  double-conversion,
  fetchFromGitHub,
  flatbuffers,
  giflib,
  gitMinimal,
  grpc,
  jsoncpp,
  lib,
  libjpeg_turbo,
  libpng,
  llvmPackages_18,
  nsync,
  protobuf,
  python3,
  snappy,
  sqlite,
  which,
  zlib,
}:

let
  # XLA requires clang 18 -- gcc and newer clang versions (e.g., 21) fail with
  # stricter template syntax checks in xla/tsl/concurrency/async_value_ref.h
  #
  # ABI comptability with other Nixpkgs stdenv-built packages can be confirmed
  # by seeing that
  #
  #   ldd $(nix-build -A xla)/lib/libservice.so 2>/dev/null | grep -E '(libstdc\+\+|libc\+\+)'
  #
  # shows libstdc++ as being linked from gcc.
  clangStdenv = llvmPackages_18.stdenv;

  pythonEnv = python3.withPackages (ps: with ps; [ numpy ]);

  # List of system libraries to use instead of bundled versions
  # Based on TensorFlow and JAX derivations
  # Note: Excluding com_google_absl due to version incompatibilities
  # (XLA expects older abseil with string_view target)
  system_libs = [
    "curl"
    "double_conversion"
    "flatbuffers"
    "gif"
    "jsoncpp_git"
    "libjpeg_turbo"
    "nsync"
    "org_sqlite"
    "png"
    "snappy"
    "zlib"
  ];
in
(buildBazelPackage.override { stdenv = clangStdenv; }) {
  pname = "xla";
  version = "0-unstable-2025-01-21";

  src = fetchFromGitHub {
    owner = "openxla";
    repo = "xla";
    rev = "e8247c3ea1d4d7f31cf27def4c7ac6f2ce64ecd4";
    hash = "sha256-ZhgMIVs3Z4dTrkRWDqaPC/i7yJz2dsYXrZbjzqvPX3E=";
  };

  bazel = bazel_7; # from .bazelversion

  nativeBuildInputs = [
    gitMinimal
    pythonEnv # necessary for some patchShebang'ing
    which
  ];

  buildInputs = [
    curl
    double-conversion
    flatbuffers
    giflib
    grpc
    jsoncpp
    libjpeg_turbo
    libpng
    nsync
    protobuf
    snappy
    sqlite
    zlib
  ];

  # Remove the .bazelversion file to allow our Bazel version
  postPatch = ''
    rm -f .bazelversion
    patchShebangs .
  '';

  # Configure XLA for CPU-only build using the official configure.py script.
  # This creates a xla_configure.bazelrc file with the appropriate options.
  # Using clang which matches XLA CI environment.
  preConfigure = ''
    ${lib.getExe pythonEnv} ./configure.py \
      --backend=CPU \
      --host_compiler=CLANG \
      --clang_path=${lib.getExe clangStdenv.cc}
  '';

  # Use system libraries where possible
  env.TF_SYSTEM_LIBS = lib.concatStringsSep "," system_libs;

  # Cannot build all of //xla/... due to missing internal-only proto targets.
  # See https://github.com/openxla/xla/issues/36720.
  bazelTargets = [
    "//xla/service:service" # Core compiler and execution service
    "//xla/client:xla_builder" # Client API for building computations
    "//xla/pjrt:pjrt_client" # PJRT runtime interface (used by JAX)
    "//xla/tools:run_hlo_module" # CLI tool for running HLO modules
  ];

  # Tests are disabled - most XLA tests are skipped in OSS builds due to tag
  # filters and size constraints. See https://github.com/openxla/xla/issues/36756.

  bazelFlags = [
    "-c opt"
    # Use sandboxed strategy for most actions, but allow local for genrules
    # and copy actions that have issues with strict sandboxing
    "--spawn_strategy=sandboxed,local"
    "--genrule_strategy=local"
    # Disable bzlmod - XLA uses WORKSPACE for deps and bzlmod would try to
    # access the Bazel Central Registry during the build phase
    "--noenable_bzlmod"
    # Work around missing includes in bundled LLVM headers
    "--cxxopt=-include"
    "--cxxopt=cstdint"
    "--host_cxxopt=-include"
    "--host_cxxopt=cstdint"
    # Exclude mobile/iOS targets that have Bazel incompatibilities
    "--build_tag_filters=-mobile,-ios"
  ];

  removeRulesCC = false;
  # Keep most local_config_* repos (CUDA, ROCm, TensorRT stubs needed at load
  # time), but remove the ones containing machine-specific /nix/store paths
  # that make the fixed-output deps hash non-reproducible. See
  # `fetchAttrs.preInstall` below.
  removeLocal = false;

  fetchAttrs = {
    sha256 = "sha256-OJfSqDlEC+yhWwwMwaD5HGvuHm8OWk+yQxmbH0/gZ88=";
    preInstall = ''
      rm -rf $bazelOut/external/{local_config_python,\@local_config_python.marker}
      rm -rf $bazelOut/external/{local_config_sh,\@local_config_sh.marker}
      rm -rf $bazelOut/external/{local_execution_config_python,\@local_execution_config_python.marker}
      rm -rf $bazelOut/external/{local_jdk,\@local_jdk.marker}
    '';
  };

  buildAttrs = {
    outputs = [ "out" ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{bin,lib,include}
    ''
    # Install built libraries
    + ''
      find bazel-bin/xla -name "*.so*" -type f -exec cp {} $out/lib \;
      find bazel-bin/xla -name "*.a" -type f -exec cp {} $out/lib \;
    ''
    # Install CLI tools
    + ''
      cp bazel-bin/xla/tools/run_hlo_module $out/bin/
    ''
    # Install headers
    + ''
      find xla -name "*.h" -type f | while read header; do
        target="$out/include/$header"
        mkdir -p "$(dirname "$target")"
        cp "$header" "$target"
      done

      runHook postInstall
    '';
  };
  meta = {
    description = "Machine learning compiler for GPUs, CPUs, and ML accelerators";
    homepage = "https://github.com/openxla/xla";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
    platforms = lib.platforms.unix;
    badPlatforms = [
      # ERROR: /build/output/external/local_config_cc/BUILD: no such target
      # '@@local_config_cc//:cc-compiler-k8': target 'cc-compiler-k8' not declared in package ''
      # defined by /build/output/external/local_config_cc/BUILD
      "aarch64-linux"

      # Bazel fails to build on darwin:
      # ERROR: no such package '@@bazel_tools~xcode_configure_extension~local_config_xcode//':
      # BUILD file not found in directory '' of external repository @@bazel_tools~xcode_configure_extension~local_config_xcode.
      # Add a BUILD file to a directory to mark it as a package.
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
