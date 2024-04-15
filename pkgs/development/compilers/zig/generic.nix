{ lib
, stdenv
, fetchFromGitHub
, cmake
, llvmPackages
, libcxx
, CoreServices
, CoreFoundation
, Foundation
, Libsystem
, libxml2
, xcbuild
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
  ] ++ (lib.optionals stdenv.isDarwin [
    xcbuild
  ]);

  buildInputs = [
    libxml2
    zlib
  ] ++ (with llvmPackages; [
    libclang
    lld
    llvm
  ]) ++ (lib.optionals stdenv.isDarwin [
    Libsystem
    CoreServices
    CoreFoundation
    Foundation
  ]);

  env.ZIG_GLOBAL_CACHE_DIR = "$TMPDIR/zig-cache";

  # Zig's build looks at /usr/bin/env to find dynamic linking info. This doesn't
  # work in Nix's sandbox. Use env from our coreutils instead.
  postPatch = ''
    substituteInPlace lib/std/zig/system/NativeTargetInfo.zig \
      --replace "/usr/bin/env" "${coreutils}/bin/env"
  ''
  + (lib.optionalString stdenv.isDarwin ''
    # To detect the SDK on Darwin, zig's build runs xcrun and xcode-select from /usr/bin instead of PATH
    substituteInPlace lib/std/zig/system/darwin.zig \
      --replace-fail "/usr/bin" "${xcbuild}/bin"

    # C++ headers have to be included BEFORE the c standard library headers
    export NIX_CFLAGS_COMPILE="-isystem ${lib.getDev llvmPackages.libcxx}/include/c++/v1 $NIX_CFLAGS_COMPILE"

    # Framework search paths are missing by default, causing linker errors
    # TODO: This doesn't actually fix them
    export NIX_LDFLAGS+=" -F${CoreFoundation}/Library/Frameworks -F${CoreServices}/Library/Frameworks -F${Foundation}/Library/Frameworks"
  '');

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
