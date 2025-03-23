{
  lib,
  runCommand,
  treefmt,
  makeBinaryWrapper,
}:
{
  name ? "treefmt-with-config",
  settings ? { },
  runtimeInputs ? [ ],
}:
runCommand name
  {
    nativeBuildInputs = [ makeBinaryWrapper ];
    treefmtExe = lib.getExe treefmt;
    binPath = lib.makeBinPath runtimeInputs;
    configFile = treefmt.buildConfig {
      # Wrap user's modules with a default file location
      _file = "<treefmt.withConfig settings arg>";
      imports = lib.toList settings;
    };
    inherit (treefmt) meta version;
  }
  ''
    mkdir -p $out/bin
    makeWrapper \
      $treefmtExe \
      $out/bin/treefmt \
      --prefix PATH : "$binPath" \
      --add-flags "--config-file $configFile"
  ''
