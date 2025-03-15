{
  lib,
  runCommand,
  treefmt,
  makeBinaryWrapper,
}:
{
  name ? "treefmt-configured",
  settings ? { },
  runtimeInputs ? [ ],
}:
runCommand name
  {
    nativeBuildInputs = [ makeBinaryWrapper ];
    treefmtExe = lib.getExe treefmt;
    binPath = lib.makeBinPath runtimeInputs;
    configFile = treefmt.buildConfig {
      _file = "<treefmt2.configure settings arg>";
      imports = lib.toList settings;
    };
    inherit (treefmt) meta;
  }
  ''
    mkdir -p $out/bin
    makeWrapper \
      $treefmtExe \
      $out/bin/treefmt \
      --prefix PATH : "$binPath" \
      --add-flags "--config-file $configFile"
  ''
