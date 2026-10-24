{
  lib,
  bootstrapStage,
  fetchpatch2,
  libllvm,
  replaceVars,
  stdenv,
}:

[
  # ClangImporter needs help finding the location of libc and libc++ (and using it).
  ./0001-Read-C-and-C-stdlib-flags-from-the-wrapped-compiler.patch
  ./0002-Use-Nixpkgs-C-and-C-stdlib-paths-in-ClangImporter.patch
  # Backport linking against an external swift-cmark.
  # From https://github.com/swiftlang/swift/pull/70791.
  ./0003-cmark-build-revamp.patch
  # Fix compilation errors when building the SIL module during bootstrap.
  # error: field has incomplete type 'clang::DeclContext::all_lookups_iterator'
  # error: field has incomplete type 'clang::DeclContext::ddiag_iterator'
  ./0004-sil-missing-headers.patch
  # Use libLTO.dylib from the LLVM built for Swift
  (replaceVars ./0005-specify-liblto-path.patch {
    libllvm_path = lib.getLib libllvm;
  })
  # Use libdispatch from nixpkgs instead of building it in-tree
  ./0006-use-nixpkgs-libdispatch.patch
  # The Swift JIT needs help finding dylibs when they are linked into the toolchain at `$out/lib`.
  (replaceVars ./0007-Help-Swift-JIT-find-the-separate-stdlib-and-framewor.patch {
    swiftPlatform = stdenv.hostPlatform.swift.platform;
  })
  # Fix missing <cstdint> when building against libstdc++ 15
  (fetchpatch2 {
    url = "https://github.com/swiftlang/swift/commit/a5c727125e952839c373fe47e9f9e359db3d4d38.patch?full_index=1";
    hash = "sha256-OoTcPyqTzAhkxaRAMeu+hab3yoIDRPq6YzK5hrLk4Jg=";
  })
  # Fix missing null-terminator on Linux, which results in a crash in `swift repl`.
  (fetchpatch2 {
    url = "https://github.com/swiftlang/swift/commit/cfbe70db5d1e65bed2388f97ee52f65719c812b3.patch?full_index=1";
    hash = "sha256-XxdP3Qs2YfT20d5E216cOQy+fUgYQpwMDWSyl77NQHw=";
  })
]
++ lib.optionals (bootstrapStage == 0) [
  # Revert optimizer changes that cause the C++-based bootstrap compiler to be unable to compile functions with
  # infinite loops that return from the loop. This doesn’t affect the later stages, so it’s applied conditionally.
  # https://github.com/swiftlang/swift/pull/79186
  ./0008-revert-optimizer-changes.patch
  # Work around a compiler crash by partially reverting https://github.com/swiftlang/swift/pull/80920.
  ./0009-siloptimizer-bootstrap-workaround.patch
]
++ lib.optionals (bootstrapStage == 1) [
  # Stage 1 doesn’t have a compiler that supports _StringProcessing.
  # This isn’t a problem on Darwin, but it fails on Linux.
  ./0010-Remove-dependency-on-_StringProcessing-during-stage-.patch
]
