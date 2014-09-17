{rubyLibsWith, callPackage, lib}:

{
  loadRubyEnv = path: config:
    let
      expr = callPackage path {};
      ruby = config.ruby;
      rubyLibs = rubyLibsWith ruby;
      gems = rubyLibs.importGems gemset (config.gemOverrides or (gemset: {}));
    in {
      inherit ruby; # TODO: Set ruby using expr.rubyVersion if not given.
      gemPath = map (drv: "${drv}") (
        builtins.filter (value: lib.isDerivation value) (lib.attrValues gems)
      );
    };
}
