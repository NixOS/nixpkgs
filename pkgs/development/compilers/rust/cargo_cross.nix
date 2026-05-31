{
  runCommand,
  stdenv,
  lib,
  pkgsBuildBuild,
  makeShellWrapper,
  rustc,
  ...
}:

runCommand "${stdenv.targetPlatform.config}-cargo-${lib.getVersion pkgsBuildBuild.cargo}"
  {
    # Use depsBuildBuild or it tries to use target-runtimeShell
    depsBuildBuild = [ makeShellWrapper ];

    inherit (pkgsBuildBuild.cargo) meta;
  }
  ''
    mkdir -p $out/bin
    ln -s ${pkgsBuildBuild.cargo}/share $out/share

    makeWrapper "${pkgsBuildBuild.cargo}/bin/cargo" "$out/bin/cargo" \
      --prefix PATH : "${rustc}/bin"
  ''
