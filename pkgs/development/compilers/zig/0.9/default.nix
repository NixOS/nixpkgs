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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = "zig";
    rev = finalAttrs.version;
    hash = "sha256-x2c4c9RSrNWGqEngio4ArW7dJjW0gg+8nqBwPcR721k=";
  };

  patches = [
    # Fix index out of bounds reading RPATH (cherry-picked from 0.10-dev)
    ./000-0.9-read-dynstr-at-rpath-offset.patch
    # Fix build on macOS 13 (cherry-picked from 0.10-dev)
    ./001-0.9-bump-macos-supported-version.patch
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

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    # ensure determinism in the compiler build
    (lib.cmakeFeature "ZIG_TARGET_MCPU" "baseline")
  ];

  env.ZIG_GLOBAL_CACHE_DIR = "$TMPDIR/zig-cache";

  doInstallCheck = true;

  strictDeps = true;

  prePatch =
    let
      zig_0_10_0 = fetchFromGitHub {
        owner = "ziglang";
        repo = "zig";
        rev = "0.10.0";
        hash = "sha256-DNs937N7PLQimuM2anya4npYXcj6cyH+dRS7AiOX7tw=";
      };
    in
    ''
      cp -R ${zig_0_10_0}/lib/libc/include/any-macos.13-any lib/libc/include/any-macos.13-any
      cp -R ${zig_0_10_0}/lib/libc/include/aarch64-macos.13-none lib/libc/include/aarch64-macos.13-gnu
      cp -R ${zig_0_10_0}/lib/libc/include/x86_64-macos.13-none lib/libc/include/x86_64-macos.13-gnu
      cp ${zig_0_10_0}/lib/libc/darwin/libSystem.13.tbd lib/libc/darwin/
    '';

  # Zig's build looks at /usr/bin/env to find dynamic linking info. This doesn't
  # work in Nix's sandbox. Use env from our coreutils instead.
  postPatch = ''
    substituteInPlace lib/std/zig/system/NativeTargetInfo.zig \
      --replace "/usr/bin/env" "${lib.getExe' coreutils "env"}"
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
