{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  llvmPackages,
  xcbuild,
  targetPackages,
  libxml2,
  ninja,
  zlib,
  coreutils,
  callPackage,
  version,
  hash,
  overrideCC,
  wrapCCWith,
  wrapBintoolsWith,
  ...
}@args:

stdenv.mkDerivation (finalAttrs: {
  pname = "zig";
  inherit version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ziglang";
    repo = "zig";
    rev = finalAttrs.version;
    inherit hash;
  };

  patches = args.patches or [ ];

  nativeBuildInputs = [
    cmake
    (lib.getDev llvmPackages.llvm.dev)
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # provides xcode-select, which is required for SDK detection
    xcbuild
  ];

  buildInputs = [
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

  strictDeps = true;

  # On Darwin, Zig calls std.zig.system.darwin.macos.detect during the build,
  # which parses /System/Library/CoreServices/SystemVersion.plist and
  # /System/Library/CoreServices/.SystemVersionPlatform.plist to determine the
  # OS version. This causes the build to fail during stage 3 with
  # OSVersionDetectionFail when the sandbox is enabled.
  __impureHostDeps = lib.optionals stdenv.hostPlatform.isDarwin [
    "/System/Library/CoreServices/.SystemVersionPlatform.plist"
  ];

  preBuild = ''
    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache";
  '';

  postPatch =
    # Zig's build looks at /usr/bin/env to find dynamic linking info. This doesn't
    # work in Nix's sandbox. Use env from our coreutils instead.
    ''
      substituteInPlace lib/std/zig/system.zig \
        --replace-fail "/usr/bin/env" "${lib.getExe' coreutils "env"}"
    ''
    # Zig tries to access xcrun and xcode-select at the absolute system path to query the macOS SDK
    # location, which does not work in the darwin sandbox.
    # Upstream issue: https://github.com/ziglang/zig/issues/22600
    # Note that while this fix is already merged upstream and will be included in 0.14+,
    # we can't fetchpatch the upstream commit as it won't cleanly apply on older versions,
    # so we substitute the paths instead.
    + lib.optionalString (stdenv.hostPlatform.isDarwin && lib.versionOlder finalAttrs.version "0.14") ''
      substituteInPlace lib/std/zig/system/darwin.zig \
        --replace-fail /usr/bin/xcrun xcrun \
        --replace-fail /usr/bin/xcode-select xcode-select
    '';

  postBuild =
    if lib.versionAtLeast finalAttrs.version "0.14" then
      ''
        stage3/bin/zig build langref --zig-lib-dir $(pwd)/stage3/lib/zig
      ''
    else
      ''
        stage3/bin/zig build langref
      '';

  postInstall = ''
    install -Dm444 ../zig-out/doc/langref.html -t $doc/share/doc/zig-${finalAttrs.version}/html
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/zig test --cache-dir "$TMPDIR/zig-test-cache" -I $src/test $src/test/behavior.zig

    runHook postInstallCheck
  '';

  passthru = import ./passthru.nix {
    inherit
      lib
      stdenv
      callPackage
      wrapCCWith
      wrapBintoolsWith
      overrideCC
      targetPackages
      ;
    zig = finalAttrs.finalPackage;
  };

  meta = {
    description = "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    homepage = "https://ziglang.org/";
    changelog = "https://ziglang.org/download/${finalAttrs.version}/release-notes.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andrewrk ];
    teams = [ lib.teams.zig ];
    mainProgram = "zig";
    platforms = lib.platforms.unix;
  };
})
