{
  lib,
  callPackage,
  cmake,
  coreutils,
  fetchFromGitHub,
  libxml2,
  llvmPackages,
  stdenv,
  testers,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zig";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = "zig";
    rev = finalAttrs.version;
    hash = "sha256-5qSiTq+UWGOwjDVZMIrAt2cDKHkyNPBSAEjpRQUByFM=";
  };

  nativeBuildInputs = [
    cmake
    (lib.getDev llvmPackages.llvm)
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

  outputs = [
    "out"
    "doc"
  ];

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    # ensure determinism in the compiler build
    (lib.cmakeFeature "ZIG_TARGET_MCPU" "baseline")
    # always link against static build of LLVM
    (lib.cmakeBool "ZIG_STATIC_LLVM" true)
  ];

  env.ZIG_GLOBAL_CACHE_DIR = "$TMPDIR/zig-cache";

  doInstallCheck = true;

  # strictDeps breaks zig when clang is being used.
  # https://github.com/NixOS/nixpkgs/issues/317055#issuecomment-2148438395
  strictDeps = !stdenv.cc.isClang;

  # Zig's build looks at /usr/bin/env to find dynamic linking info. This doesn't
  # work in Nix's sandbox. Use env from our coreutils instead.
  postPatch = ''
    substituteInPlace lib/std/zig/system.zig \
      --replace "/usr/bin/env" "${lib.getExe' coreutils "env"}"
  '';

  postBuild = ''
    stage3/bin/zig build langref
  '';

  postInstall = ''
    install -Dm444 ../zig-out/doc/langref.html -t $doc/share/doc/zig-${finalAttrs.version}/html
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/zig test --cache-dir "$TMPDIR/zig-test-cache" -I $src/test $src/test/behavior.zig

    runHook postInstallCheck
  '';

  passthru = {
    hook = callPackage ./hook.nix { zig = finalAttrs.finalPackage; };
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "zig version";
      };
    };
  };

  meta = {
    description = "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    changelog = "https://ziglang.org/download/${finalAttrs.version}/release-notes.html";
    homepage = "https://ziglang.org/";
    license = lib.licenses.mit;
    mainProgram = "zig";
    maintainers = with lib.maintainers; [ andrewrk ] ++ lib.teams.zig.members;
    platforms = lib.platforms.unix;
  };
})
