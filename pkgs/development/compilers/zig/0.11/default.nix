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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = "zig";
    rev = finalAttrs.version;
    hash = "sha256-iuU1fzkbJxI+0N1PiLQM013Pd1bzrgqkbIyTxo5gB2I=";
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

  strictDeps = true;

  # Zig's build looks at /usr/bin/env to find dynamic linking info. This doesn't
  # work in Nix's sandbox. Use env from our coreutils instead.
  postPatch = ''
    substituteInPlace lib/std/zig/system/NativeTargetInfo.zig \
      --replace "/usr/bin/env" "${lib.getExe' coreutils "env"}"
  '';

  postBuild = ''
    stage3/bin/zig run ../tools/docgen.zig -- ../doc/langref.html.in langref.html --zig $PWD/stage3/bin/zig
  '';

  postInstall = ''
    install -Dm444 -t $doc/share/doc/zig-$version/html langref.html
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/zig test --cache-dir "$TMPDIR/zig-test-cache" -I $src/test $src/test/behavior.zig

    runHook postInstallCheck
  '';

  passthru = {
    hook = callPackage ./hook.nix { zig = finalAttrs.finalPackage; };
    cc = callPackage ../cc.nix { zig = finalAttrs.finalPackage; };
    stdenv = callPackage ../stdenv.nix { zig = finalAttrs.finalPackage; };
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "zig version";
      };
    };
  };

  meta = {
    description = "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    homepage = "https://ziglang.org/";
    changelog = "https://ziglang.org/download/${finalAttrs.version}/release-notes.html";
    license = lib.licenses.mit;
    mainProgram = "zig";
    maintainers = with lib.maintainers; [ andrewrk ] ++ lib.teams.zig.members;
    platforms = lib.platforms.unix;
  };
})
