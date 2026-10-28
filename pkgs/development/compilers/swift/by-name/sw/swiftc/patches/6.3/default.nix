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
  ../6.2/0001-Read-C-and-C-stdlib-flags-from-the-wrapped-compiler.patch
  ../6.2/0002-Use-Nixpkgs-C-and-C-stdlib-paths-in-ClangImporter.patch
  # Backport linking against an external swift-cmark.
  # From https://github.com/swiftlang/swift/pull/70791.
  ../6.2/0003-cmark-build-revamp.patch
  # Fix compilation errors when building the SIL module during bootstrap.
  # error: field has incomplete type 'clang::DeclContext::all_lookups_iterator'
  # error: field has incomplete type 'clang::DeclContext::ddiag_iterator'
  ../6.2/0004-sil-missing-headers.patch
  # Use libLTO.dylib from the LLVM built for Swift
  (replaceVars ../6.2/0005-specify-liblto-path.patch {
    libllvm_path = lib.getLib libllvm;
  })
  # Use libdispatch from nixpkgs instead of building it in-tree
  ../6.2/0006-use-nixpkgs-libdispatch.patch
  # The Swift JIT needs help finding dylibs when they are linked into the toolchain at `$out/lib`.
  (replaceVars ../6.2/0007-Help-Swift-JIT-find-the-separate-stdlib-and-framewor.patch {
    swiftPlatform = stdenv.hostPlatform.swift.platform;
  })
  # Fix missing null-terminator on Linux, which results in a crash in `swift repl`.
  (fetchpatch2 {
    url = "https://github.com/swiftlang/swift/commit/cfbe70db5d1e65bed2388f97ee52f65719c812b3.patch?full_index=1";
    hash = "sha256-XxdP3Qs2YfT20d5E216cOQy+fUgYQpwMDWSyl77NQHw=";
  })
]
