{rubyLibsWith, callPackage, lib, fetchurl, fetchgit}:

let

  sourceInstantiators = {
    # Many ruby people use `git ls-files` to compose their gemspecs.
    git = (attrs: fetchgit { inherit (attrs) url rev sha256 leaveDotGit; });
    url = (attrs: fetchurl { inherit (attrs) url sha256; });
  };

in

{
  # Loads a set containing a ruby environment definition. The set's `gemset`
  # key is expected to contain a set of gems. Optionally, the `ruby_version`
  # key can be set to a string. A gem definition looks like this:
  #
  #  rack-test = {
  #    name = "rack-test-0.6.2";
  #    src = {
  #      type = "url";
  #      url = "https://rubygems.org/downloads/rack-test-0.6.2.gem";
  #      sha256 = "01mk715ab5qnqf6va8k3hjsvsmplrfqpz6g58qw4m3l8mim0p4ky";
  #    };
  #    dependencies = [ "rack" ];
  #  };
  loadRubyEnv = path: config:
    let
      expr = import path;
      gemset = lib.mapAttrs (name: attrs:
        attrs // {
          src = (builtins.getAttr attrs.src.type sourceInstantiators) attrs.src;
          dontBuild = !(attrs.src.type == "git");
        }
      ) expr.gemset;
      ruby = config.ruby;
      rubyLibs = rubyLibsWith ruby;
      gems = rubyLibs.importGems gemset (config.gemOverrides or (gemset: {}));
    in {
      inherit ruby gems; # TODO: Set ruby using expr.rubyVersion if not given.
      gemPath = map (drv: "${drv}") (
        builtins.filter (value: lib.isDerivation value) (lib.attrValues gems)
      );
    };
}
