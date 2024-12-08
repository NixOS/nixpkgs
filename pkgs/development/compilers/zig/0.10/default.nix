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
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = "zig";
    rev = finalAttrs.version;
    hash = "sha256-69QIkkKzApOGfrBdgtmxFMDytRkSh+0YiaJQPbXsBeo=";
  };

  patches = [
    # Backport alignment related panics from zig-master to 0.10.
    # Upstream issue: https://github.com/ziglang/zig/issues/14559
    ./001-0.10-macho-fixes.patch
  ];

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
    # always link against static build of LLVM
    (lib.cmakeBool "ZIG_STATIC_LLVM" true)
    # ensure determinism in the compiler build
    (lib.cmakeFeature "ZIG_TARGET_MCPU" "baseline")
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
    ./zig2 run ../doc/docgen.zig -- ./zig2 ../doc/langref.html.in langref.html
  '';

  postInstall = ''
    install -Dm644 -t $doc/share/doc/zig-$version/html ./langref.html
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
