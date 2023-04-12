{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, pkg-config
, cmake
, ninja
, git
, doxygen
, sphinx
, lit
, libxml2
, libxcrypt
, libedit
, libffi
, mpfr
, zlib
, ncurses
, python3Packages
, buildDocs ? true
, buildMan ? true
, buildTests ? true
, targetName ? "llvm"
, targetDir ? "llvm"
, targetProjects ? [ ]
, targetRuntimes ? [ ]
# "NATIVE" resolves into x86 or aarch64 depending on stdenv
, llvmTargetsToBuild ? [ "NATIVE" ]
, extraPatches ? [ ]
, extraNativeBuildInputs ? [ ]
, extraBuildInputs ? [ ]
, extraCMakeFlags ? [ ]
, extraPostPatch ? ""
, checkTargets ? [(
  lib.optionalString buildTests (
    if targetDir == "runtimes"
    then "check-runtimes"
    else "check-all"
  )
)]
, extraPostInstall ? ""
, extraLicenses ? [ ]
, isBroken ? false
}:

let
  llvmNativeTarget =
    if stdenv.isx86_64 then "X86"
    else if stdenv.isAarch64 then "AArch64"
    else throw "Unsupported ROCm LLVM platform";
  inferNativeTarget = t: if t == "NATIVE" then llvmNativeTarget else t;
  llvmTargetsToBuild' = [ "AMDGPU" ] ++ builtins.map inferNativeTarget llvmTargetsToBuild;
in stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-llvm-${targetName}";
  version = "5.4.4";

  outputs = [
    "out"
  ] ++ lib.optionals buildDocs [
    "doc"
  ] ++ lib.optionals buildMan [
    "man"
    "info" # Avoid `attribute 'info' missing` when using with wrapCC
  ];

  patches = extraPatches;

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "llvm-project";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-BDvC6QFDFtahA9hmJDLiM6K4mrO3j9E9rEXm7KulcuA=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    git
    python3Packages.python
  ] ++ lib.optionals (buildDocs || buildMan) [
    doxygen
    sphinx
    python3Packages.recommonmark
  ] ++ lib.optionals (buildTests && !finalAttrs.passthru.isLLVM) [
    lit
  ] ++ extraNativeBuildInputs;

  buildInputs = [
    libxml2
    libxcrypt
    libedit
    libffi
    mpfr
  ] ++ extraBuildInputs;

  propagatedBuildInputs = lib.optionals finalAttrs.passthru.isLLVM [
    zlib
    ncurses
  ];

  sourceRoot = "${finalAttrs.src.name}/${targetDir}";

  cmakeFlags = [
    "-DLLVM_TARGETS_TO_BUILD=${builtins.concatStringsSep ";" llvmTargetsToBuild'}"
  ] ++ lib.optionals (finalAttrs.passthru.isLLVM && targetProjects != [ ]) [
    "-DLLVM_ENABLE_PROJECTS=${lib.concatStringsSep ";" targetProjects}"
  ] ++ lib.optionals ((finalAttrs.passthru.isLLVM || targetDir == "runtimes") && targetRuntimes != [ ]) [
    "-DLLVM_ENABLE_RUNTIMES=${lib.concatStringsSep ";" targetRuntimes}"
  ] ++ lib.optionals (finalAttrs.passthru.isLLVM || finalAttrs.passthru.isClang) [
    "-DLLVM_ENABLE_RTTI=ON"
    "-DLLVM_ENABLE_EH=ON"
  ] ++ lib.optionals (buildDocs || buildMan) [
    "-DLLVM_INCLUDE_DOCS=ON"
    "-DLLVM_BUILD_DOCS=ON"
    # "-DLLVM_ENABLE_DOXYGEN=ON" Way too slow, only uses one core
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DLLVM_ENABLE_OCAMLDOC=OFF"
    "-DSPHINX_OUTPUT_HTML=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
  ] ++ lib.optionals buildTests [
    "-DLLVM_INCLUDE_TESTS=ON"
    "-DLLVM_BUILD_TESTS=ON"
  ] ++ lib.optionals (buildTests && !finalAttrs.passthru.isLLVM) [
    "-DLLVM_EXTERNAL_LIT=${lit}/bin/.lit-wrapped"
  ] ++ extraCMakeFlags;

  postPatch = lib.optionalString finalAttrs.passthru.isLLVM ''
    patchShebangs lib/OffloadArch/make_generated_offload_arch_h.sh
  '' + lib.optionalString (buildTests && finalAttrs.passthru.isLLVM) ''
    # FileSystem permissions tests fail with various special bits
    rm test/tools/llvm-objcopy/ELF/mirror-permissions-unix.test
    rm unittests/Support/Path.cpp

    substituteInPlace unittests/Support/CMakeLists.txt \
      --replace "Path.cpp" ""
  '' + extraPostPatch;

  doCheck = buildTests;
  checkTarget = lib.concatStringsSep " " checkTargets;

  postInstall = lib.optionalString finalAttrs.passthru.isLLVM ''
    # `lit` expects these for some test suites
    mv bin/{FileCheck,not,count,yaml2obj,obj2yaml} $out/bin
  '' + lib.optionalString buildMan ''
    mkdir -p $info
  '' + extraPostInstall;

  passthru = {
    isLLVM = targetDir == "llvm";
    isClang = targetDir == "clang" || builtins.elem "clang" targetProjects;

    updateScript = rocmUpdateScript {
      name = finalAttrs.pname;
      owner = finalAttrs.src.owner;
      repo = finalAttrs.src.repo;
    };
  };

  meta = with lib; {
    description = "ROCm fork of the LLVM compiler infrastructure";
    homepage = "https://github.com/RadeonOpenCompute/llvm-project";
    license = with licenses; [ ncsa ] ++ extraLicenses;
    maintainers = with maintainers; [ acowley lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = isBroken;
  };
})
