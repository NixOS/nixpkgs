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
  ./0006-use-nixpkgs-libdispatch.patch
  # We need to be able to build the stdlib on Darwin even if we don’t use most of it because we need to be able to
  # generate the text-based stubs and module definitions for use with the system frameworks.
  #
  # Swift 6.4 adds availability annotations to the Backtracing APIs. While it is possible to change the OS version used
  # to make this build (see: https://github.com/swiftlang/swift/commit/c432e9df61858bc8372ff06a855d34c9448ff93e), we
  # want the versions in the module interfaces to match those shipped with Xcode and the SDK.
  #
  # Disabling the checks while keeping the annotations lets us do that.
  ./0008-Disable-availability-checking-when-building-the-Runt.patch
  # Building the _Differentiation module needs _Builtin_float on Darwin.
  ./0009-Fix-_Differentiation-module-build-on-Darwin.patch
]
