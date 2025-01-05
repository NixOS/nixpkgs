{
  lib,
  runCommand,
  rustc,
  minimalContent ? true,
}:

runCommand "rust-src" { } ''
  tar -xzf ${rustc.src}
  mv rustc-${rustc.version}-src $out
  rm -rf $out/{${
    lib.concatStringsSep "," (
      [
        "ci"
        "doc"
        "etc"
        "grammar"
        "llvm-project"
        "llvm-emscripten"
        "rtstartup"
        "rustllvm"
        "test"
        "vendor"
      ]
      ++ lib.optionals minimalContent [
        "tools"
        "stdarch"
      ]
    )
  }}
''
