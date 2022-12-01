{ pkgs
, callPackage
, lispDerivation
, lisp
}:

with pkgs.lib;
with callPackage ./utils.nix {};

{
  # Build a lisp derivation from this source, for the specific given
  # systems. When two separate packages include the same src, but both for a
  # different system, it resolves to the same derivation.
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

    # Extra directories to add to the ASDF search path for systems. Shouldn’t be
    # necessary—only use this to fix external packages you don’t control. For
    # your own packages, I urge you to put all the .asds in your root
    # directory. This argument is localized, i.e. it can be either a literal
    # value, or it can be a 1-arg function accepting a list of systems for which
    # this final derivation is being built, and return any value it wants
    # depending on that list.
    lispAsdPath ? [],

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

      # Normalised value of the systems argument to this derivation. All
      # internal access to that arg ("what system(s) am I loaded with?") should
      # be through this value.
      lispSystemsArg = args.lispSystems or [ args.lispSystem ];

      # Create a single source map entry for this derivation. This is the core
      # datastructure around which the derivation deduplication detection
      # mechanism is built.
      entryFor = drv: { ${derivPath drv.origSrc} = drv; };
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

      mySrc = derivPath _lispOrigSrc;
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
      allDepsDerivs = pipe allDeps [
        attrValues
        (map (d: [ (b.toString d) ] ++ (map (x: "${d}/${x}") (d.lispAsdPath or []))))
        flatten
        l.naturalSort
      ];

      # Must be :-join’ed and eval’ed before use.
      fullAsdPath = [ "$PWD" ] ++
                    # Must localize the path first because it depends on which
                    # systems are being built
                    (map (x: "$PWD/${x}") (localizedArgs.lispAsdPath or [])) ++
                    allDepsDerivs;

      ####
      #### THE FINAL DERIVATION
      ####

      # I use naturalSort because it’s an easy way to sort a list strings in Nix
      # but any sort will do. What’s important is that this is deterministically
      # sorted.
      lispSystems' = normaliseStrings lispSystemsArg;
      # Clean out the arguments to this function which aren’t deriv props. Leave
      # in the systems because it’s a useful and harmless prop.
      derivArgs = removeAttrs args ["lispDependencies" "lispCheckDependencies" "lispSystem" "_lispDeduplicateMyself" "_lispOrigSrc"];
      pname = args.pname or "${b.concatStringsSep "_" lispSystems'}";

      # Add here all "standard" derivation args which are system
      # dependent. Meaning these can be either strings as per, or functions, in
      # which case they will be called with the set of systems enabled for this
      # derivation. This is used to fix auto deduplication (unioning / joining)
      # of lisp derivations.
      stdArgs = [
        # Standard args that are not phases
        "nativeBuildInputs"
        "buildInputs"
        "patches"
        "outputs"
        "shellHook"
        "makeFlags"
        # Am I forgetting anything?

        # And a custom property which is also useful to vary per system
        "lispAsdPath"

        # All the phases
        "preUnpack"
        "unpackPhase"
        "postUnpack"

        "prePatch"
        "patchPhase"
        "postPatch"

        "preConfigure"
        "configurePhase"
        "postConfigure"

        "preBuild"
        "buildPhase"
        "postBuild"

        "preCheck"
        "checkPhase"
        "postCheck"

        "preInstall"
        "installPhase"
        "postInstall"

        "preFixup"
        "fixupPhase"
        "postFixup"

        "preDist"
        "distPhase"
        "postDist"
      ];
      localizedArgs = a.mapAttrs (_: callIfFunc lispSystems') (optionalKeys stdArgs args);

      # For dev shell only: a human readable comma-separated list of all
      # dependency systems loaded by this derivation.
      allDepsHumanReadable = pipe allDeps [
        attrValues
        (flatMap (d: d.lispSystems))
        normaliseStrings
        (s.concatStringsSep ", ")
      ];

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
      _lispOrigSrc = args._lispOrigSrc or src;

      me = pkgs.stdenv.mkDerivation (derivArgs // {
        lispSystems = lispSystems';
        name = args.name or "system-${pname}";
        passthru = (derivArgs.passthru or {}) // {
          inherit
            # Invariant: this never includes myself.
            allDeps
            # Give others access to the args with which I was built
            args;
          # The original, non-deduplicated src we were called with
          origSrc = _lispOrigSrc;
          # (There is probably a neater, more idiomatic way to do this
          # overriding business.)
          merge = other:
            # CAREFUL!! You can merge recursively! That means the body of this
            # function must not evaluate any properties that cause any recursive
            # properties to be evaluated. This only works because Nix is lazily
            # evaluated.
            # Not technically necessary but it makes for slightly cleaner API.
            assert isLispDeriv other;
            assert mySrc == derivPath other.origSrc;
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
                  # These args are "carried over" from the original, “human”
                  # invocation of lispDerivation. These args are safe across
                  # deduplication.
                  inherit _lispOrigSystems _lispOrigSrc;
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
          enableCheck = if doCheck
                        then me
                        else lispDerivation (args // { doCheck = true; });
        };
        # Store .fasl files next to the respective .lisp file
        ASDF_OUTPUT_TRANSLATIONS = "/:/";
        setAsdfPath = ''
          export CL_SOURCE_REGISTRY="''${CL_SOURCE_REGISTRY+$CL_SOURCE_REGISTRY:}${b.concatStringsSep ":" fullAsdPath}"
        '';
        # Like lisp-modules-new, pre-build every package independently.
        #
        # Reason to do this: packages like libuv contain quite complex build
        # steps, and letting the final derivation do all the work becomes
        # untenable.
        buildPhase = ''
          runHook preBuild

          eval "$setAsdfPath"
          echo "Build CL_SOURCE_REGISTRY: $CL_SOURCE_REGISTRY"
          ${callLisp lisp (asdfOpScript lispBuildOp pname lispSystems')}

          runHook postBuild
        '';
        installPhase = ''
          runHook preInstall

          cp -R "." "$out"

          runHook postInstall
        '';
        checkPhase = ''
          runHook preCheck

          eval "$setAsdfPath"
          echo "Check CL_SOURCE_REGISTRY: $CL_SOURCE_REGISTRY"
          ${callLisp lisp (asdfOpScript "test-system" pname _lispOrigSystems)}

          runHook postCheck
        '';
      } // localizedArgs // {
        # Put this one at the very end because we don’t override the
        # user-specified shellHook; we extend it, if it exists. So this is a
        # non-destructive operation.
        shellHook = ''
eval "$setAsdfPath"
>&2 cat <<EOF
Lisp dependencies available to ASDF: ${allDepsHumanReadable}.
(see \$CL_SOURCE_REGISTRY for full paths.)

Example:

    $ sbcl
    > (require :asdf)
    > (asdf:load-system :some-system)

The working directory's systems are also available, if any.
EOF
'' + (localizedArgs.shellHook or "");
      });
    in
      # If I depend on myself in any way, first flatten me and all my transitive
      # dependent copies of me into one big union derivation.
      if _lispDeduplicateMyself && allDepsIncMyself ? ${mySrc}
      then me.merge allDepsIncMyself.${mySrc}
      else me;

    #hly-nixpkgs.url = "github:hraban/nixpkgs/feat/lisp-packages-lite";
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

  # Get a binary executable lisp which can load the given systems from ASDF
  # without any extra setup necessary.
  lispWithSystems = systems: lispDerivation {
    inherit (lisp) name;
    lispSystem = "";
    buildInputs = [ pkgs.makeWrapper ];
    src = pkgs.writeText "mock" "source";
    dontUnpack = true;
    dontBuild = true;
    lispDependencies = systems;
    installPhase = ''
      ls -1 ${lisp}/bin | while read f; do
        makeWrapper ${lisp}/bin/$f $out/bin/$f \
          ''${CL_SOURCE_REGISTRY+--set CL_SOURCE_REGISTRY $CL_SOURCE_REGISTRY} \
          --set ASDF_OUTPUT_TRANSLATIONS $ASDF_OUTPUT_TRANSLATIONS
      done
    '';
  };
}
