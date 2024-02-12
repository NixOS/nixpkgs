{ lib
, stdenv
, fetchFromGitHub
, cmake
, llvmPackages
, libxml2
, zlib
, coreutils
, callPackage
, ...
}:

args:

stdenv.mkDerivation (finalAttrs: {
  pname = "zig";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = "zig";
    rev = finalAttrs.version;
    inherit (args) hash;
  };

  nativeBuildInputs = [
    cmake
    llvmPackages.llvm.dev
  ];

  buildInputs = [
    libxml2
    zlib
  ] ++ (with llvmPackages; [
    libclang
    lld
    llvm
  ]);

  env.ZIG_GLOBAL_CACHE_DIR = "$TMPDIR/zig-cache";

  # Zig's build looks at /usr/bin/env to find dynamic linking info. This doesn't
  # work in Nix's sandbox. Use env from our coreutils instead.
  postPatch = ''
    substituteInPlace lib/std/zig/system/NativeTargetInfo.zig \
      --replace "/usr/bin/env" "${coreutils}/bin/env"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/zig test --cache-dir "$TMPDIR/zig-test-cache" -I $src/test $src/test/behavior.zig

    runHook postInstallCheck
  '';

  passthru = {
    hook = callPackage ./hook.nix {
      zig = finalAttrs.finalPackage;
    };
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
} // removeAttrs args [ "hash" ])
