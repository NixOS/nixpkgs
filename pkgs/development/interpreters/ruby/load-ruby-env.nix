{ pkgs, lib, callPackage, gemFixes, fetchurl }:

{ gemset, ruby ? pkgs.ruby, fixes ? gemFixes }@args:

let
  const = x: y: x;

  buildRubyGem = callPackage ./gem.nix { inherit ruby; };

  fetchers.gem = attrs: fetchurl {
    url = "${attrs.src.source or "https://rubygems.org"}/downloads/${attrs.name}-${attrs.version}.gem";
    inherit (attrs.src) sha256;
  };

  instantiate = (attrs:
    let
      gemPath = map (name: gemset''."${name}") (attrs.dependencies or []);
      fixedAttrs = attrs // (fixes."${attrs.name}" or (const {})) attrs;
    in
      buildRubyGem (
        fixedAttrs // {
          name = "${attrs.name}-${attrs.version}";
          src = fetchers."${attrs.src.type}" attrs;
          inherit gemPath;
        }
      )
  );

  gemset' = if builtins.isAttrs gemset then gemset else callPackage gemset { };

  gemset'' = lib.flip lib.mapAttrs gemset' (name: attrs:
    if (lib.isDerivation attrs)
      then attrs
      else instantiate (attrs // { inherit name; })
  );

in gemset''
