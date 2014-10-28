{ pkgs, lib, callPackage, gemFixes }:

{ gemset, ruby ? pkgs.ruby, fixes ? gemFixes }@args:

let
  const = x: y: x;

  buildRubyGem = callPackage ./gem.nix { inherit ruby; };

  instantiate = (name: attrs:
    let
      gemPath = map (name: gemset''."${name}") (attrs.dependencies or []);
      fixedAttrs = attrs // (fixes."${name}" or (const {})) attrs;
    in
      buildRubyGem (fixedAttrs // { name = "${name}-${attrs.version}"; inherit gemPath; })
  );

  gemset' = if builtins.isAttrs gemset then gemset else callPackage gemset { };

  gemset'' = lib.flip lib.mapAttrs gemset' (name: attrs:
    if (lib.isDerivation attrs) then attrs
    else (instantiate name attrs)
  );

in gemset''
