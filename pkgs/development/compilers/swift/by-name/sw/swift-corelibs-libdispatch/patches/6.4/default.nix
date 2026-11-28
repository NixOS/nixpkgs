{ }:

[
  ./0001-gnu-install-dirs.patch
  # Nixpkgs includes `sys/cdefs.h` from Alpine, which breaks the build due to `-Werror`.
  ../6.2/0002-Don-t-include-sys-cdefs-on-Musl.patch
]
