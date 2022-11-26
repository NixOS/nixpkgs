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

{
  pkgs ? import ../../.. {},
  lisp ? pkgs.sbcl
}:

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
  rpipe = flip pipe;

  # Like foldr but without a nul-value. Doesn’t support actual ‘null’ in the
  # list because I don’t know how to make singletons (is that even possible in
  # Nix?) and because I don’t care.
  reduce = (op: seq:
    assert ! b.elem null seq; # N.B.: THIS MAKES IT STRICT!
    foldr (a: b: if b == null then a else (op a b)) null seq);

  # Create an empty string with the same context as the given string
  emptyCopyWithContext = str: s.addContextFrom str "";

  # Turn a derivation path into a context-less string. I suspect this isn’t in
  # the stdlib because this is a perversion of a low-level feature, not intended
  # for casual access in regular derivations.
  drvStrWithoutContext = rpipe [ toString b.getContext attrNames l.head ];

  # optionalKeys [ "a" "b" ] { a = 1; b = 2; c = 3; }
  # => { a = 1; b = 2; }
  # optionalKeys [ ] { a = 1; b = 2; c = 3; }
  # => { }
  # optionalKeys [ "a" "b" ] { a = 1; }
  # => { a = 1; }
  # optionalKeys [ "a" "b" ] { }
  # => { }
  optionalKeys = keys: a.filterAttrs (k: v: b.elem k keys);

  # Like the inverse of lists.remove but takes a test function instead of an
  # element
  # (a -> Bool) -> [a] -> [a]
  keepBy = f: foldr (a: b: l.optional (f a) a ++ b) [];

  # If argument is a function, call it with a constant value. Otherwise pass it
  # through.
  callIfFunc = val: f: if isFunction f then f val else f;

  normaliseStrings = rpipe [ l.unique l.naturalSort ];

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
  #
  # Tip:
  # - nestedUnion head 1 [ a b ] == b // a
  # - nestedUnion tail 1 [ a b ] == a // b
  nestedUnion = item: n: sets:
    if n == 0
    then item sets
    else
      a.zipAttrsWith (_: vals: nestedUnion item (n - 1) vals) sets;

  getLispDeps = x: x.CL_SOURCE_REGISTRY or "";

  lisp-asdf-op = op: sys: "(asdf:${op} :${sys})";

  asdf = pkgs.fetchFromGitLab {
    name = "asdf-src";
    domain = "gitlab.common-lisp.net";
    owner = "asdf";
    repo = "asdf";
    rev = "3.3.6";
    sha256 = "sha256-GCmGUMLniPakjyL/D/aEI93Y6bBxjdR+zxXdSgc9NWo=";
  };

  asdfOpScript = op: name: systems: pkgs.writeText "${op}-${name}.lisp" ''
    (require :asdf)
    ${b.concatStringsSep "\n" (map (lisp-asdf-op op) systems)}
  '';

  # Internal convention for lisp: a function which takes a file and returns a
  # shell invocation calling that file, then exiting. External API: same, but
  # you can also just pass a derivation instead and it is converted, if
  # recognized. E.g. lisp = pkgs.sbcl.
  callLisp = lisp:
    if b.isFunction lisp
    then lisp
    else
      assert isDerivation lisp;
      {
        sbcl = file: ''"${lisp}/bin/sbcl" --script "${file}"'';
        ecl = file: ''"${lisp}/bin/ecl" --shell "${file}"'';
      }.${lisp.pname};

  # Get a context-less string representing this source derivation, come what
  # come may.
  derivPath = src: drvStrWithoutContext (
    if b.isPath src
    # Purely a developer ergonomics feature. Don’t rely on this for published
    # libs. It breaks pure eval.
    then b.path { path = src; }
    else src);

  isLispDeriv = x: x ? lispSystems;

  # Get the derivation path of the original source code of this derivation,
  # recursively passing through derivations until we hit an actual source
  # derivation.
  # TODO: Is this recursive algo a good idea for bona fide .src = lispDerivation
  # {} .. ? Doesn’t sound like it. We’re phasing out the entire
  # behind-the-scenes .src rewriting so I think we can leave off the recursion
  # here.
  srcPath = drv: if drv ? src && isLispDeriv drv
                 then srcPath drv.src
                 else derivPath drv;

  # Internal helper function: build a lisp derivation from this source, for the
  # specific given systems. The idea here is that when two separate packages
  # include the same src, but both for a different system, using a (caller
  # managed) systems map they end up passing the same list of systems to this
  # function, and it ends up resolving to the same derivation.
  lispDerivation = {
    # The system(s) defined by this derivation
    lispSystem ? null,
    lispSystems ? null,
    # The lisp dependencies FOR this derivation
    lispDependencies ? [],
    lispCheckDependencies ? [],
    CL_SOURCE_REGISTRY ? "",
    # If you were to build this from source. Not necessarily the final src of
    # the actual derivation; that depends on the dependency chain.
    src,
    doCheck ? false,

    # Example:
    # - lispBuildOp = "make",
    # - lispBuildOp = "load-system",
    # - lispBuildOp = "operate 'asdf:load-op",
    # - lispBuildOp = "operate 'asdf:compile-bundle-op",
    # - lispBuildOp = "operate 'asdf:monolithic-deliver-asd-op"
    # If you control the source, though, you are much better off configuring the
    # defsystem in the .asd to do the right thing when called as ‘make’.
    lispBuildOp ? "make",

    # As the name suggests:
    # - this is a private arg for internal recursion purposes -- do not use
    # - this indicates whether I want to deduplicate myself. It is used to
    #   terminate the self deduplication recursion without segfaulting.
    _lispDeduplicateMyself ? true,

    ...
  } @ args:
    # Mutually exclusive args but one is required. XOR.
    assert (lispSystem == null) != (lispSystems == null);
    let
      ####
      #### DEPENDENCY GRAPH
      ####

      lispSystemsArg = args.lispSystems or [ args.lispSystem ];

      # Create a single source map entry for this derivation. This is the core
      # datastructure around which the derivation deduplication detection
      # mechanism is built.
      entryFor = drv: { ${srcPath drv} = drv; };
      # Given a lispDerivation, get all its dependencies in the { src-drv =>
      # lisp-drv } format. The invariant for lispDerivation.allDeps is that it
      # can’t contain itself, so this is a non-destructive operation.
      depsFor = dep: dep.allDeps // (entryFor dep);

      # Create a { src-drv => lisp-drv } describing all of MY
      # dependencies. Worst edge case:
      #
      #                -> foo-b -> zim
      #              /               \
      # foo-a -> bar                  \
      #              \                 v
      #                ------------> foo-c
      #
      # Assuming foo-* are all systems in the same source derivation. This edge
      # case is the most complicated, and it’s the reason for this entire
      # pre-parsing-dependency-tracking quagmire. It’s not unusual with -test
      # derivations. This graph is solved by incrementally including the
      # dependent systems in the parent derivations, and rebuilding them
      # all. So, with an arrow indicating the lispDependencies:
      #
      # [foo-a & foo-b & foo-c] -> bar -> [foo-b & foo-c] -> zim -> foo-c
      #
      # Complications:
      # - The derivation doing the deduplication of foo-b and foo-c is not,
      #   itself, a foo, so it doesn’t have easy access to an authoritative
      #   definition of foo. It must recognize from the two separate derivations
      #   that they are equal, and construct an entirely new foo that
      #   encapsulates them both.
      # - If any of the systems is defined with doCheck = true, this affects the
      #   build, and the final combined derivation must also be built with
      #   checks.
      # - If you rebuild fully from source every time, e.g. foo-{a,b,c}, foo-c
      #   will only be built because it is a dependency of zim. ASDF’s cache
      #   tracking mechanism causes any system /whose dependencies must be
      #   rebuilt/ itself also stale. This means a rebuild of foo-c would cause
      #   a rebuild of zim--that will fail, because zim is in the store. The
      #   only solution to this is to fetch the prebuilt cache of foo-c by
      #   making foo-c the src of foo-b, and foo-b the src of foo-a.
      #
      # Note that bar only depends on a single "foo" derivation, which is built
      # with foo-b and foo-c; not on two copies of foo, one with b & c, one with
      # just c.

      mySrc = srcPath src;
      lispDependencies' = lispDependencies ++ (optionals doCheck lispCheckDependencies);
      # Always order dependencies deterministically.
      # If either of the two is not a lisp deriv, we’re basically in the foo-b
      # situation. This situation only happens when we are in a derivation
      # that has itself as a dependency. It never occurs from an unrelated
      # dependency, because those will never have an entry for this src
      # anyway.
      #
      # We are in the “bar” situation, above. Or perhaps in this situation:
      #
      #          -- blub-a
      #        /
      # bim --
      #        \
      #          -- blub-b
      #
      # Either way, the solution is the same: create an entirely new
      # derivation that unions the two dependencies.
      allDepsIncMyself = nestedUnion (reduce (x: x.merge)) 1 (map depsFor lispDependencies');
      allDeps = removeAttrs allDepsIncMyself [ mySrc ];

      # All derivations I depend on, directly or indirectly, without me. Sort
      # deterministically to avoid rebuilding the same derivation just because
      # the order of dependencies was different (in the envvar).
      allDepsDerivs = pipe allDeps [attrValues (map b.toString) l.naturalSort];

      ####
      #### THE FINAL DERIVATION
      ####

      # I use naturalSort because it’s an easy way to sort a list strings in Nix
      # but any sort will do. What’s important is that this is deterministically
      # sorted.
     lispSystems' = normaliseStrings lispSystemsArg;
      # Clean out the arguments to this function which aren’t deriv props. Leave
      # in the systems because it’s a useful and harmless prop.
      derivArgs = removeAttrs args ["lispDependencies" "lispCheckDependencies" "lispSystem" "_lispDeduplicateMyself"];
      pname = "${b.concatStringsSep "_" lispSystems'}";

      # Add here all "standard" derivation args which we want to make system
      # dependent, if desired (meaning the user specified them as a function).
      stdArgs = [
        # I still don’t understand the difference between these two. Isn’t that
        # crazy? In all of the internet there isn’t a single “here’s what this
        # actually is” example. I did find a fifty page github discussion
        # lamenting the lack of such an explanation. Without anyone ever
        # actually giving one. Pretty wild.
        "nativeBuildInputs"
        "buildInputs"
        "buildPhase"
        "installPhase"
        "patches"
      ];
      localizedArgs = a.mapAttrs (_: callIfFunc lispSystems') (optionalKeys stdArgs args);

      # Secret arg to track how we were originally invoked by the end user. This
      # only matters for tests: for regular builds, you want to ‘make’
      # everything, but for tests you specifically really only want to test the
      # specific system that was originally requested. This matters because
      # tracking test dependencies can become tricky. Don’t forget that merging
      # transitively dependent lisp systems for the same source repository into
      # a single derivation is only really a convenience feature to help marry
      # Nix and ASDF; it is not in fact something that the user necessarily
      # cares about.
      _lispOrigSystems = args._lispOrigSystems or lispSystems';
      me = pkgs.stdenv.mkDerivation (derivArgs // {
        inherit pname;
        lispSystems = lispSystems';
        name = "system-${pname}";
        passthru = (derivArgs.passthru or {}) // {
          # Give others access to the args with which I was built
          inherit args;
          # (There is probably a neater, more idiomatic way to do this
          # overriding business.)
          merge = other:
            # CAREFUL!! You can merge recursively! That means the body of this
            # function must not evaluate any properties that cause any recursive
            # properties to be evaluated. This only works because Nix is lazily
            # evaluated.
            # Not technically necessary but it makes for slightly cleaner API.
            assert isLispDeriv other;
            assert mySrc == srcPath other;
            let
              # The new arguments that define this merged derivation: which
              # systems do you build, and are you in check mode y/n? The
              # dependencies are automatically inferred when necessary.

              # Don’t get the lispSystems from the original args: we want to
              # know what the final, real collection of lisp system names was
              # that was used for this derivation.
              newLispSystems = normaliseStrings (lispSystems' ++ other.lispSystems);
              newDoCheck = doCheck || other.args.doCheck or false;
            in
              # Only build a new one if it improves on both existing
              # derivations.
              if newDoCheck == other.doCheck && newLispSystems == other.lispSystems
              then other.overrideAttrs (_: { inherit _lispOrigSystems; })
              # N.B.: Only propagate ME if I have equal doCheck to other. This
              # is subtly different from newDoCheck == doCheck. It solves the
              # problem where a doCheck = true depends (transitively) on itself
              # with doCheck false: that should /not/ be deduplicated, because
              # some dependency in the middle clearly depends on me (with
              # doCheck = false), so if I deduplicate I will end up re-building
              # my non-test files here, which will cause a rebuild in that
              # already-built-dependency.
              else if doCheck == other.doCheck && newLispSystems == lispSystems'
              then me
              else
                # Patches are removed because I assume the source to already have
                # been patched by now. For it is myself.
                lispDerivation ((removeAttrs args ["patches" "lispSystem"]) // {
                  # By this point, we assume that this top level derivation
                  # contains all its own recursive self-dependencies and doesn’t
                  # need any more deduplication.
                  _lispDeduplicateMyself = false;
                  inherit _lispOrigSystems;
                  lispDependencies = l.unique (lispDependencies ++ other.args.lispDependencies or []);
                  lispCheckDependencies = l.unique (lispCheckDependencies ++ other.args.lispCheckDependencies or []);
                  doCheck = newDoCheck;
                  lispSystems = newLispSystems;
                  # Important: we assume all the other args are automatically
                  # compatible for the new derivation, notably buildPhase,
                  # patches, etc. This means you can’t define two separate
                  # systems from the same source (foo-b and foo-c) and give each
                  # a distinct buildPhase--rather, you must define a single
                  # buildPhase as a function which takes an array of system
                  # names as an arg, and decides based on that arg what to
                  # do. There is special support for this in the lispDerivation.

                  # And now for the pièce de résistence:
                  src = other;
                });
          # Invariant: this never includes myself.
          inherit allDeps;
          enableCheck = if doCheck
                        then me
                        else lispDerivation (args // { doCheck = true; });
        };
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
          ${callLisp lisp (asdfOpScript lispBuildOp pname lispSystems')}
        '';
        installPhase = ''
          cp -R "." "$out"
        '';
        checkPhase = ''
          # Import current package from PWD
          export CL_SOURCE_REGISTRY="$PWD''${CL_SOURCE_REGISTRY:+:$CL_SOURCE_REGISTRY}"
          ${callLisp lisp (asdfOpScript "test-system" pname _lispOrigSystems)}
        '';
      } // localizedArgs // (a.optionalAttrs (length allDepsDerivs > 0) {
        # It looks like this is instantiated for every single derivation
        # which is /technically/ unnecessary--you could get away with only
        # doing this for derivations that actually get built--but to be
        # frank it doesn’t matter a lot. N.B.: Appended to the empty string
        # recursive.
        # TODO: Don’t override existing CL_SOURCE_REGISTRY.
        CL_SOURCE_REGISTRY = s.concatStringsSep ":" allDepsDerivs;
      }));
    in
      # If I depend on myself in any way, first flatten me and all my transitive
      # dependent copies of me into one big union derivation.
      if _lispDeduplicateMyself && allDepsIncMyself ? ${mySrc}
      then me.merge allDepsIncMyself.${mySrc}
      else me;

  # If a single src derivation specifies multiple lisp systems, you can use this
  # helper to define them.
  lispMultiDerivation = args: a.mapAttrs (name: system:
    let
      namearg = a.optionalAttrs (! system ? lispSystems) { lispSystem = name; };
    in
      # Default system name is the derivation name in the containing ‘systems’
      # attrset, but can be overridden if the Lisp name is incompatible with Nix
      # identifiers.
      lispDerivation ((removeAttrs args ["systems"]) // namearg // system)
  ) args.systems;

  lispPackages = callPackage ./packages.nix { };
};
in
{
  inherit (root)
    lispDerivation
    lispMultiDerivation
    lispPackages;
  # Also include the packages top level for convenience
} // root.lispPackages
