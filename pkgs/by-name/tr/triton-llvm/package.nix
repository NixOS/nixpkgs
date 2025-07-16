{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgsBuildBuild,
  pkg-config,
  cmake,
  ninja,
  git,
  libxml2,
  libxcrypt,
  libedit,
  libffi,
  libpfm,
  lit,
  mpfr,
  zlib,
  ncurses,
  doxygen,
  sphinx,
  which,
  sysctl,
  python3Packages,
  buildDocs ? true,
  buildMan ? true,
  buildTests ? true,
  llvmTargetsToBuild ? [ "NATIVE" ], # "NATIVE" resolves into x86 or aarch64 depending on stdenv
  llvmProjectsToBuild ? [
    "llvm"
    "mlir"
  ],
}:

let
  llvmNativeTarget =
    if stdenv.hostPlatform.isx86_64 then
      "X86"
    else if stdenv.hostPlatform.isAarch64 then
      "AArch64"
    else
      throw "Currently unsupported LLVM platform '${stdenv.hostPlatform.config}'";

  inferNativeTarget = t: if t == "NATIVE" then llvmNativeTarget else t;
  llvmTargetsToBuild' = [
    "AMDGPU"
    "NVPTX"
  ] ++ builtins.map inferNativeTarget llvmTargetsToBuild;

  # This LLVM version can't seem to find pygments/pyyaml,
  # but a later update will likely fix this (triton-2.1.0)
  python =
    if buildTests then
      python3Packages.python.withPackages (
        p: with p; [
          psutil
          pygments
          pyyaml
        ]
      )
    else
      python3Packages.python;

  isNative = stdenv.hostPlatform == stdenv.buildPlatform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "triton-llvm";
  version = "21.0.0-git"; # See https://github.com/llvm/llvm-project/blob/main/cmake/Modules/LLVMVersion.cmake

  outputs =
    [
      "out"
    ]
    ++ lib.optionals buildDocs [
      "doc"
    ]
    ++ lib.optionals buildMan [
      "man"
    ];

  # See https://github.com/triton-lang/triton/blob/main/cmake/llvm-hash.txt
  src = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "a66376b0dc3b2ea8a84fda26faca287980986f78";
    hash = "sha256-7xUPozRerxt38UeJxA8kYYxOQ4+WzDREndD2+K0BYkU=";
  };

  nativeBuildInputs =
    [
      pkg-config
      cmake
      ninja
      git
      python
    ]
    ++ lib.optionals (buildDocs || buildMan) [
      doxygen
      sphinx
      python3Packages.recommonmark
      python3Packages.myst-parser
    ];

  buildInputs = [
    libxml2
    libxcrypt
    libedit
    libffi
    libpfm
    mpfr
  ];

  propagatedBuildInputs = [
    zlib
    ncurses
  ];

  preConfigure = ''
    cd llvm
  '';

  cmakeFlags =
    [
      (lib.cmakeFeature "LLVM_TARGETS_TO_BUILD" (lib.concatStringsSep ";" llvmTargetsToBuild'))
      (lib.cmakeFeature "LLVM_ENABLE_PROJECTS" (lib.concatStringsSep ";" llvmProjectsToBuild))
      (lib.cmakeFeature "LLVM_HOST_TRIPLE" stdenv.hostPlatform.config)
      (lib.cmakeFeature "LLVM_DEFAULT_TARGET_TRIPLE" stdenv.hostPlatform.config)
      (lib.cmakeBool "LLVM_INSTALL_UTILS" true)
      (lib.cmakeBool "LLVM_INCLUDE_DOCS" (buildDocs || buildMan))
      (lib.cmakeBool "MLIR_INCLUDE_DOCS" (buildDocs || buildMan))
      (lib.cmakeBool "LLVM_BUILD_DOCS" (buildDocs || buildMan))
      # Way too slow, only uses one core
      # (lib.cmakeBool "LLVM_ENABLE_DOXYGEN" (buildDocs || buildMan))
      (lib.cmakeBool "LLVM_ENABLE_SPHINX" (buildDocs || buildMan))
      (lib.cmakeBool "SPHINX_OUTPUT_HTML" buildDocs)
      (lib.cmakeBool "SPHINX_OUTPUT_MAN" buildMan)
      (lib.cmakeBool "SPHINX_WARNINGS_AS_ERRORS" false)
      (lib.cmakeBool "LLVM_INCLUDE_TESTS" buildTests)
      (lib.cmakeBool "MLIR_INCLUDE_TESTS" buildTests)
      (lib.cmakeBool "LLVM_BUILD_TESTS" buildTests)
      # Cross compilation code taken/modified from LLVM 16 derivation
    ]
    ++ lib.optionals (!isNative) (
      let
        nativeToolchainFlags =
          let
            nativeCC = pkgsBuildBuild.targetPackages.stdenv.cc;
            nativeBintools = nativeCC.bintools.bintools;
          in
          [
            (lib.cmakeFeature "CMAKE_C_COMPILER" "${nativeCC}/bin/${nativeCC.targetPrefix}cc")
            (lib.cmakeFeature "CMAKE_CXX_COMPILER" "${nativeCC}/bin/${nativeCC.targetPrefix}c++")
            (lib.cmakeFeature "CMAKE_AR" "${nativeBintools}/bin/${nativeBintools.targetPrefix}ar")
            (lib.cmakeFeature "CMAKE_STRIP" "${nativeBintools}/bin/${nativeBintools.targetPrefix}strip")
            (lib.cmakeFeature "CMAKE_RANLIB" "${nativeBintools}/bin/${nativeBintools.targetPrefix}ranlib")
          ];

        # We need to repass the custom GNUInstallDirs values, otherwise CMake
        # will choose them for us, leading to wrong results in llvm-config-native
        nativeInstallFlags = [
          (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" (placeholder "out"))
          (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "${placeholder "out"}/bin")
          (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "${placeholder "out"}/include")
          (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "${placeholder "out"}/lib")
          (lib.cmakeFeature "CMAKE_INSTALL_LIBEXECDIR" "${placeholder "out"}/libexec")
        ];
      in
      [
        (lib.cmakeBool "CMAKE_CROSSCOMPILING" true)
        (lib.cmakeFeature "CROSS_TOOLCHAIN_FLAGS_NATIVE" (
          lib.concatStringsSep ";" (
            lib.concatLists [
              nativeToolchainFlags
              nativeInstallFlags
            ]
          )
        ))
      ]
    );

  postPatch =
    # `CMake Error: cannot write to file "/build/source/llvm/build/lib/cmake/mlir/MLIRTargets.cmake": Permission denied`
    ''
      chmod +w -R ./mlir
      patchShebangs ./mlir/test/mlir-reduce
    ''
    # FileSystem permissions tests fail with various special bits
    + ''
      rm llvm/test/tools/llvm-objcopy/ELF/mirror-permissions-unix.test
      rm llvm/unittests/Support/Path.cpp

      substituteInPlace llvm/unittests/Support/CMakeLists.txt \
        --replace-fail "Path.cpp" ""
    ''
    # Not sure why this fails
    + ''
      rm mlir/test/Dialect/SPIRV/IR/availability.mlir
      rm mlir/test/Dialect/SPIRV/IR/target-env.mlir
    ''
    # Not sure why this fails
    + lib.optionalString stdenv.hostPlatform.isAarch64 ''
      rm llvm/test/tools/llvm-exegesis/AArch64/latency-by-opcode-name.s
    '';

  postInstall =
    ''
      cp ${lib.getExe lit} $out/bin/llvm-lit
    ''
    + (lib.optionalString (!isNative) ''
      cp -a NATIVE/bin/llvm-config $out/bin/llvm-config-native
    '');

  doCheck = buildTests;

  nativeCheckInputs = [ which ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ sysctl ];

  checkTarget = "check-all";
  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage = "https://github.com/llvm/llvm-project";
    changelog = "https://github.com/llvm/llvm-project/releases/tag/llvmorg-${finalAttrs.version}";
    license = with lib.licenses; [ ncsa ];
    maintainers = with lib.maintainers; [
      SomeoneSerge
      Madouura
    ];
    platforms = with lib.platforms; aarch64 ++ x86;
  };
})
