{ ruby, lib, callPackage, gemFixes, fetchurl, fetchgit, buildRubyGem }@defs:

# This function builds a set of gems. You first convert your Gemfile to an attrset
# called a "gemset", and then use this function to build the gemset.
#
# A gemset looks like the following:
#
#   {
#     libv8 = {
#       version = "3.16.14.7";
#       src = {
#         type = "gem";
#         sha256 = "...";
#       };
#     };
#     therubyracer = {
#       version = "0.12.1";
#       dependencies = [ "libv8" ];
#       src = {
#         type = "gem";
#         sha256 = "...";
#       };
#     };
#   }
#
# If you use these gems as build inputs, the GEM_PATH will be updated
# appropriately, and command like `bundle exec` should work out of the box.

{ gemset, ruby ? defs.ruby, fixes ? gemFixes }@args:

let
  const = x: y: x;

  fetchers.path = attrs: attrs.src.path;
  fetchers.gem = attrs: fetchurl {
    url = "${attrs.src.source or "https://rubygems.org"}/downloads/${attrs.name}-${attrs.version}.gem";
    inherit (attrs.src) sha256;
  };
  fetchers.git = attrs: fetchgit {
    inherit (attrs.src) url rev sha256 fetchSubmodules;
    leaveDotGit = true;
  };

  instantiate = (attrs:
    let
      defaultAttrs = {
        name = "${attrs.name}-${attrs.version}";
        inherit ruby gemPath;
      };
      gemPath = map (name: gemset''."${name}") (attrs.dependencies or []);
      fixedAttrs = attrs // (fixes."${attrs.name}" or (const {})) attrs;
      withSource = fixedAttrs //
        (if (lib.isDerivation fixedAttrs.src || builtins.isString fixedAttrs.src)
           then {}
           else { src = (fetchers."${fixedAttrs.src.type}" fixedAttrs); });

    in
      buildRubyGem (withSource // defaultAttrs)
  );

  gemset' = if builtins.isAttrs gemset then gemset else import gemset;

  gemset'' = lib.flip lib.mapAttrs gemset' (name: attrs:
    if (lib.isDerivation attrs)
      then attrs
      else instantiate (attrs // { inherit name; })
  );

in gemset''
