{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  targetPackages,
  libxml2,
  zlib,
  coreutils,
  callPackage,
  version,
  hash,
  patches ? [ ],
  overrideCC,
  wrapCCWith,
  wrapBintoolsWith,
}@args:

stdenv.mkDerivation (finalAttrs: {
  pname = "zig";
  inherit version;

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = "zig";
    rev = finalAttrs.version;
    inherit hash;
  };

  patches = args.patches or [ ];

  nativeBuildInputs = [
    cmake
    (lib.getDev llvmPackages.llvm.dev)
  ];

  buildInputs =
    [
      libxml2
      zlib
    ]
    ++ (with llvmPackages; [
      libclang
      lld
      llvm
    ]);

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    # ensure determinism in the compiler build
    (lib.cmakeFeature "ZIG_TARGET_MCPU" "baseline")
    # always link against static build of LLVM
    (lib.cmakeBool "ZIG_STATIC_LLVM" true)
  ];

  outputs = [
    "out"
    "doc"
  ];

  # strictDeps breaks zig when clang is being used.
  # https://github.com/NixOS/nixpkgs/issues/317055#issuecomment-2148438395
  strictDeps = !stdenv.cc.isClang;

  # On Darwin, Zig calls std.zig.system.darwin.macos.detect during the build,
  # which parses /System/Library/CoreServices/SystemVersion.plist and
  # /System/Library/CoreServices/.SystemVersionPlatform.plist to determine the
  # OS version. This causes the build to fail during stage 3 with
  # OSVersionDetectionFail when the sandbox is enabled.
  __impureHostDeps = lib.optionals stdenv.hostPlatform.isDarwin [
    "/System/Library/CoreServices/.SystemVersionPlatform.plist"
    "/System/Library/CoreServices/SystemVersion.plist"
  ];

  preBuild = ''
    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache";
  '';

  # Zig's build looks at /usr/bin/env to find dynamic linking info. This doesn't
  # work in Nix's sandbox. Use env from our coreutils instead.
  postPatch =
    if lib.versionAtLeast finalAttrs.version "0.12" then
      ''
        substituteInPlace lib/std/zig/system.zig \
          --replace-fail "/usr/bin/env" "${coreutils}/bin/env"
      ''
    else
      ''
        substituteInPlace lib/std/zig/system/NativeTargetInfo.zig \
          --replace-fail "/usr/bin/env" "${coreutils}/bin/env"
      '';

  postBuild =
    if lib.versionAtLeast finalAttrs.version "0.13" then
      ''
        stage3/bin/zig build langref
      ''
    else
      ''
        stage3/bin/zig run ../tools/docgen.zig -- ../doc/langref.html.in langref.html --zig $PWD/stage3/bin/zig
      '';

  postInstall =
    if lib.versionAtLeast finalAttrs.version "0.13" then
      ''
        install -Dm444 ../zig-out/doc/langref.html -t $doc/share/doc/zig-${finalAttrs.version}/html
      ''
    else
      ''
        install -Dm444 langref.html -t $doc/share/doc/zig-${finalAttrs.version}/html
      '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/zig test --cache-dir "$TMPDIR/zig-test-cache" -I $src/test $src/test/behavior.zig

    runHook postInstallCheck
  '';

  passthru = {
    hook = callPackage ./hook.nix { zig = finalAttrs.finalPackage; };

    bintools-unwrapped = callPackage ./bintools.nix { zig = finalAttrs.finalPackage; };
    bintools = wrapBintoolsWith { bintools = finalAttrs.finalPackage.bintools-unwrapped; };

    cc-unwrapped = callPackage ./cc.nix { zig = finalAttrs.finalPackage; };
    cc = wrapCCWith {
      cc = finalAttrs.finalPackage.cc-unwrapped;
      bintools = finalAttrs.finalPackage.bintools;
      nixSupport.cc-cflags =
        [
          "-target"
          "${stdenv.targetPlatform.parsed.cpu.name}-${stdenv.targetPlatform.parsed.kernel.name}-${stdenv.targetPlatform.parsed.abi.name}"
        ]
        ++ lib.optional (
          stdenv.targetPlatform.isLinux && !(stdenv.targetPlatform.isStatic or false)
        ) "-Wl,-dynamic-linker=${targetPackages.stdenv.cc.bintools.dynamicLinker}";
    };

    stdenv = overrideCC stdenv finalAttrs.finalPackage.cc;
  };

  meta = {
    description = "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    homepage = "https://ziglang.org/";
    changelog = "https://ziglang.org/download/${finalAttrs.version}/release-notes.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andrewrk ] ++ lib.teams.zig.members;
    mainProgram = "zig";
    platforms = lib.platforms.unix;
  };
})
