{ runCommand, rustc }:

runCommand "rust-lib-src" { } ''
  tar --strip-components=1 -xzf ${rustc.src}
  mv library $out
''
