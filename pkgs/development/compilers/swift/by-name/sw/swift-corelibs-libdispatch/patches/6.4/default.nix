{ fetchpatch2 }:

[
  ./0001-gnu-install-dirs.patch
  # Nixpkgs includes `sys/cdefs.h` from Alpine, which breaks the build due to `-Werror`.
  ../6.2/0002-Don-t-include-sys-cdefs-on-Musl.patch
  # Fixes `error: variable '_dispatch_program_is_probably_callback_driven' set but not used` error with Clang 23.
  (fetchpatch2 {
    url = "https://github.com/swiftlang/swift-corelibs-libdispatch/commit/d545f73a398604cd4cd495ca5b1e74f24d0d72e5.patch?full_index=1";
    hash = "sha256-9drePQi6nILy7ti4CIxqPWmfLEJ8j4OS7DLxl/9DOy8=";
  })
]
