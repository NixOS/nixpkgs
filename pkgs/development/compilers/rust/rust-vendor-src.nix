{ runCommand, rustc }:

runCommand "rust-vendor-src" { } ''
  tar --strip-components=1 -xzf ${rustc.src}
  mv vendor $out
''
