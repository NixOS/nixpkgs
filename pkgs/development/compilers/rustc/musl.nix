{ stdenv, pkgs, musl }:
pkgs.rustc.overrideDerivation(oldAttrs: {
  name = "rustc-musl-${oldAttrs.version}";
  configureFlags = oldAttrs.configureFlags ++ [
    "--target=x86_64-unknown-linux-musl"
    "--musl-root=${musl}"
  ];
})
