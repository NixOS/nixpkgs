{ fetchpatch2 }:

[
  ./0001-gnu-install-dirs.patch
  # Nixpkgs includes `sys/cdefs.h` from Alpine, which breaks the build due to `-Werror`.
  ./0002-Don-t-include-sys-cdefs-on-Musl.patch
  # Fixes `implicit conversion changes signedness` error.
  (fetchpatch2 {
    url = "https://github.com/swiftlang/swift-corelibs-libdispatch/commit/38872e2d44d66d2fb94186988509defc734888a5.patch?full_index=1";
    hash = "sha256-BXTv79ej93CBrHtEzHDu+3WkIfzEctwyqBoPkNQQkAA=";
  })
]
