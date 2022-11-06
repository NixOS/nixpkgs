{ pkgs ? import ../../.. {} }:

with pkgs.lib;

# Wrap everything in a top level struct for callPackage
let root = rec {
  a = attrsets;
  b = builtins;
  l = lists;
  s = strings;
  t = trivial;
  callPackage = callPackageWith ({ inherit pkgs; } // root);

  # The obvious signature for pipe. Who wants ltr? (Clarification: putting the
  # function pipeline first and the value second allows using rpipe in
  # point-free context. See other uses in this file.)
  rpipe = t.flip pipe;

  # Turn a derivation path into an actual derivation object. When cast to a
  # string, a derivation object becomes its out path, rather than the .drv file.
  # (Is this normal the normal way to do this?)
  load_deriv = drv: import drv;

  # Get all context /derivations/ for this string. I have a feeling this is not
  # what contexts are for. Or, actually, they kind of are, really.
  getContexts = rpipe [ b.getContext b.attrNames (map load_deriv) ];
  # (example of point-free rpipe)

  # Join all context derivations of str by the given separator. DISCARDS ACTUAL
  # CONTENTS OF STR!
  joinContext = sep: str: s.concatStringsSep sep (getContexts str);

  # Create an empty string with the same context as the given string
  emptyCopyWithContext = str: s.addContextFrom str "";

  # Turn a derivation path into a context-less string. There is a reason this is
  # not in the stdlib.
  drvStrWithoutContext = rpipe [ toString b.getContext b.attrNames l.head ];

  # optionalKeys [ "a" "b" ] { a = 1; b = 2; c = 3; }
  # => { a = 1; b = 2; }
  # optionalKeys [ ] { a = 1; b = 2; c = 3; }
  # => { }
  # optionalKeys [ "a" "b" ] { a = 1; }
  # => { a = 1; }
  # optionalKeys [ "a" "b" ] { }
  # => { }
  optionalKeys = keys: a.filterAttrs (k: v: b.elem k keys);

  # This is a /nested/ union operation on attrsets: if you have e.g. a 2-layer
  # deep set (so a set of sets, so [ { String => { String => T } } ]), you can
  # pass 2 here to union them all.
  #
  # s = [
  #       { foo = { foo-bar = true ; foo-bim = true ; } ; }
  #       { foo = { foo-zom = true ; } ; bar = { bar-a = true ; } ; }
  # ]
  #
  # nestedUnion (_: true) 1 s
  # => { foo = true; bar = true; }
  # nestedUnion (_: true) 2 s
  # => {
  #      bar = { bar-a = true; };
  #      foo = { foo-bar = true; foo-bim = true; foo-zom = true; };
  #    }
  #
  # This convention is inspired by the representation of string context.
  #
  # The item function is a generator for the leaf nodes. It is passed the list
  # of values to union.
  nestedUnion = item: n: sets:
    if n == 0
    then item sets
    else
      a.zipAttrsWith (_: vals: nestedUnion item (n - 1) vals) sets;

  getLispDeps = x: x.CL_SOURCE_REGISTRY or "";

  lisp-load-op = sys: "(asdf:load-system :${sys})";

  buildScript = name: systems: pkgs.writeText "load-${name}.lisp" ''
    (require :asdf)
    ${b.concatStringsSep "\n" (map lisp-load-op systems)}
  '';

  # TODO: Customizable lisp.
  sbcl = file: ''"${pkgs.sbcl}/bin/sbcl" --script "${file}"'';

  # If argument is a function, call it with a constant value. Otherwise pass it
  # through.
  callIfFunc = val: f: if t.isFunction f then f val else f;

  # Internal helper function: build a lisp derivation from this source, for the
  # specific given systems. The idea here is that when two separate packages
  # include the same src, but both for a different system, using a (caller
  # managed) systems map they end up passing the same list of systems to this
  # function, and it ends up resolving to the same derivation.
  lispDerivationForSystems = {
    lispSystems,
    lisp,
    lispDependencies ? [],
    CL_SOURCE_REGISTRY ? "",
    ...
  } @ args:
    assert length lispSystems > 0;
    let
      # I use naturalSort because it’s an easy way to sort a list strings in Nix
      # but any sort will do. What’s important is that this is deterministically
      # sorted.
      systems' = l.naturalSort lispSystems;
      # Clean out the arguments to this function which aren’t deriv props. Leave
      # in the systems because it’s a useful and harmless prop.
      derivArgs = b.removeAttrs args ["lispDependencies" "lisp"];
      pname = "${b.concatStringsSep "_" systems'}";

      # Add here all "standard" derivation args which we want to make system
      # dependent.
      stdArgs = [
        "buildInputs"
        "buildPhase"
        "installPhase"
      ];
      localizedArgs = a.mapAttrs (_: callIfFunc systems') (optionalKeys stdArgs args);
    in
      pkgs.stdenv.mkDerivation (derivArgs // {
        inherit pname;
        name = "system-${pname}";
        # Store .fasl files next to the respective .lisp file
        ASDF_OUTPUT_TRANSLATIONS = "/:/";
        # Like lisp-modules-new, pre-build every package independently.
        #
        # Reason to do this: packages like libuv contain quite complex build
        # steps, and letting the final derivation do all the work becomes
        # untenable.
        # TODO: How to combine this with user supplied args? What’s the expected
        # UX?
        buildPhase = ''
          # Import current package from PWD
          export CL_SOURCE_REGISTRY="$PWD''${CL_SOURCE_REGISTRY:+:$CL_SOURCE_REGISTRY}"
          env | grep CL_SOURCE_REGISTRY
          ${lisp (buildScript pname systems')}
        '';
        installPhase = ''
          cp -R "." "$out"
        '';
      } // localizedArgs //  (
        if length lispDependencies == 0
        then
          { }
        else
          let
            # This is a bit crazy but long story short I’m using string contexts
            # as a set datatype, and their string concatenation as the union
            # operation. It’s horrible and it fits this use case perfectly.
            shallow = l.foldr s.addContextFrom CL_SOURCE_REGISTRY lispDependencies;
            recursive = s.concatStrings ([ shallow ] ++ (map (rpipe [getLispDeps emptyCopyWithContext]) lispDependencies));
          in
            {
              # It looks like this is instantiated for every single derivation
              # which is /technically/ unnecessary--you could get away with only
              # doing this for derivations that actually get built--but to be
              # frank it doesn’t matter a lot. N.B.: Appended to the empty string
              # recursive.
              # TODO: Don’t override existing CL_SOURCE_REGISTRY.
              CL_SOURCE_REGISTRY = recursive + (joinContext ":" recursive);
            }));

  # Get a context-less string representing this source derivation, come what
  # come may.
  srcDrv = src: drvStrWithoutContext (
    if b.isPath src
    # Purely a developer ergonomics feature. Don’t rely on this for published
    # libs. It breaks pure eval.
    then b.path { path = src; }
    else src);

  # Derivation for a (set of) system(s) which must be directly loadable from the
  # given source by ASDF. It’s ok for a single source to specify multiple
  # systems. If different systems have different (lisp) dependencies, you can
  # specify multiple copies of this same derivation with different
  # lispDependency properties, as long as they all reference the exact same src
  # derivation. This derivation will automatically deduplicate itself,
  # recursively.
  #
  # This derivation can be used as a top-level derivation, or as a dependency in
  # another lispDerivation. In the latter case, it will automatically inherit
  # its parent’s dependency chain to determine which of the systems to build for
  # this specific src. Example: cl-async with the same source could be asked to
  # build either cl-async or cl-async-ssl; if both are included in the final
  # build, this derivation will evaluate to exactly the same derivation for both
  # separate invocations, ensuring only one copy of cl-async is included in the
  # final derivation. Notably, this avoids confusing ASDF at load time because
  # there is now only one, deterministic place to get the final cl-async code.
  lispDerivation = {
    # The system to extract from this source. Short-hand for lispSystems.
    lispSystem ? null,
    # All lisp systems provided by this package which are included externally
    # and not internally. That is: systems which are /actually/ used in your
    # app. E.g. cl-async defines (among others) cl-async-ssl: if you don’t use
    # that, you don’t need to pass it here.
    lispSystems ? null,
    lispDependencies ? [],
    src,
    ...
  } @ args:
    # Mutually exclusive args but one is required. XOR.
    assert (lispSystem == null) != (lispSystems == null);
    let
      lispSystems' = args.lispSystems or [ args.lispSystem ];
      derivArgs = b.removeAttrs args [ "sourceToSystems" ];
      mySrcDrv = srcDrv src;
      myEntry = {
        ${mySrcDrv} = {
          systems = b.listToAttrs (map (name: { inherit name; value = true; }) lispSystems');
          deps = b.listToAttrs (map (dep: { name = srcDrv dep.src; value = dep; }) lispDependencies);
        };
      };
      allEntries = [ myEntry ] ++ map (dep: dep.sourceToSystems) lispDependencies;
      # The entire map of all source derivations used in this entire dependency
      # chain, to the systems used from those derivations. This solves the case
      # where a source repo defines multiple systems, and you only want to use a
      # subset.
      #
      # Entry :: { "systems" = { String => true }; "deps" = { Deriv => dep; }; }
      # Map :: { String => Entry }
      #
      # The outer layer is the derivation path, the inner layer is an entry for
      # every system name, the list of derivations is a list of dependencies.
      sourceToSystems = args.sourceToSystems or (nestedUnion b.head 3 allEntries);
      # Given a full sourceToSystems map, extract /all/ my dependencies from
      # that map, removing any potential recursive dependencies.
      allMyDeps = a.attrValues (a.filterAttrs (drv: dep: drv != mySrcDrv) sourceToSystems.${mySrcDrv}.deps);
    in
      lispDerivationForSystems (derivArgs // {
        passthru = (args.passtrhu or {}) // {
          # Allow overriding the map with which this deriv was built. This
          # isn’t intended for overriding an existing map (when would you do
          # that anyway; that arg is internal only); rather, this allows me to
          # use any lispDerivation as both a top-level derivation
          # (i.e. without any sourceToSystems arg), but also as a
          # dependency. If Nix were greedy evaluated, this would make every
          # dependency (recursively) first (spuriously) evaluate its entire
          # dependency graph before discarding it all when it realises it’s
          # being used as a dependency itself, but because of lazy evaluation,
          # that should (!?) never happen.  Because this prop is removed from
          # the final derivation, I don’t think we can use overrideAttrs for
          # this.
          overrideSystemsMap = sourceToSystems:
            lispDerivation (args // { inherit sourceToSystems; });
          # This is only called lazily on demand anyway
          inherit sourceToSystems;
        };
        # Look, this is that override thing in action.
        lispDependencies = map (dep: dep.overrideSystemsMap sourceToSystems) allMyDeps;
        lisp = sbcl;
        lispSystems = b.attrNames sourceToSystems.${mySrcDrv}.systems;
      });

  # If a single src derivation specifies multiple lisp systems, you can use this
  # helper to define them.
  lispMultiDerivation = args: a.mapAttrs (name: system:
    let
      namearg = a.optionalAttrs (! a.hasAttrByPath ["lispSystems"] system) { lispSystem = name; };
    in
      # Default system name is the derivation name in the containing ‘systems’
      # attrset, but can be overridden if the Lisp name is incompatible with Nix
      # identifiers.
      lispDerivation ((b.removeAttrs args ["systems"]) // namearg // system)
  ) args.systems;

  lispPackages = callPackage ./packages.nix { };
};
in
{
  inherit (root) lispMultiDerivation lispDerivation sbcl;
} // root.lispPackages

# Copyright © 2022  Hraban Luyat
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
