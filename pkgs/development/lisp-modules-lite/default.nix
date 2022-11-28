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
  pkgs
  , lib
  , newScope

  , lisp ? pkgs.sbcl
}:

lib.makeScope newScope (self:
with self;

with lib;

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

  inherit (callPackage (self: with self; lispMultiDerivation {
    src = pkgs.fetchFromGitHub {
      name = "3bmd-src";
      owner = "3b";
      repo = "3bmd";
      rev = "125c92389ded253a506ff394eb2c0dab3fc78acc";
      sha256 = "sha256-mbb9dWDDp+wJYDj59QsyZv7ZTsc83cxqba34Xp9mApM=";
    };
    systems = {
      _3bmd = {
        lispSystem = "3bmd";
        lispDependencies = [ alexandria esrap split-sequence ];
      };
      _3bmd-ext-code-blocks = {
        lispSystem = "3bmd-ext-code-blocks";
        lispDependencies = [ _3bmd alexandria colorize split-sequence ];
      };
    };
  }) {}) _3bmd _3bmd-ext-code-blocks;

  alexandria = callPackage ({}: lispify [ ] (pkgs.fetchFromGitLab {
    name = "alexandria-src";
    domain = "gitlab.common-lisp.net";
    owner = "alexandria";
    repo = "alexandria";
    rev = "v1.4";
    sha256 = "sha256-1Hzxt65dZvgOFIljjjlSGgKYkj+YBLwJCACi5DZsKmQ=";
  })) {};

  anaphora = callPackage (self: with self; lispDerivation {
    lispSystem = "anaphora";
    lispCheckDependencies = [ rt ];
    src = pkgs.fetchFromGitHub {
      name = "anaphora-src";
      owner = "spwhitton";
      repo = "anaphora";
      rev = "0.9.8";
      sha256 = "sha256-CzApbUmdDmD+BWPcFGJN0rdZu991354EdTDPn8FSRbc=";
    };
  }) {};

  array-utils = callPackage (self: with self; lispDerivation {
    lispSystem = "array-utils";
    lispCheckDependencies = [ parachute ];
    src = pkgs.fetchFromGitHub {
      name = "array-utils-src";
      owner = "Shinmera";
      repo = "array-utils";
      rev = "40cea8fc895add87d1dba9232da817750222b528";
      sha256 = "sha256-jcVm7dXVj69XrP8Ggl9bZWZ9Ultth/AFUkpANFVr9jQ=";
    };
  }) {};

  arrow-macros = callPackage (self: with self; lispDerivation {
    lispSystem = "arrow-macros";

    src = pkgs.fetchFromGitHub {
      name = "arrow-macros-src";
      owner = "hipeta";
      repo = "arrow-macros";
      rev = "0.2.7";
      sha256 = "sha256-r8zNLtBtk02xgz8oDM49sYs84SZya42GJaoHFnE/QZA=";
    };

    lispDependencies = [ alexandria ];
    lispCheckDependencies = [ fiveam ];
  }) {};

  asdf = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitLab {
    name = "asdf-src";
    domain = "gitlab.common-lisp.net";
    owner = "asdf";
    repo = "asdf";
    rev = "3.3.6";
    sha256 = "sha256-GCmGUMLniPakjyL/D/aEI93Y6bBxjdR+zxXdSgc9NWo=";
  })) {};

  asdf-flv = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "net.didierverna.asdf-flv-src";
    owner = "didierverna";
    repo = "asdf-flv";
    rev = "version-2.1";
    sha256 = "sha256-5IFe7OZgQ9bgaqtTcvoyA5aJPy+KbtuKRA9ygbciCYA=";
  })) {};

  assoc-utils = callPackage (self: with self; lispDerivation {
    lispSystem = "assoc-utils";
    src = pkgs.fetchFromGitHub {
      name = "assoc-utils-src";
      owner = "fukamachi";
      repo = "assoc-utils";
      rev = "483a22ef42995f84fac00d11fb27ace671480153";
      sha256 = "sha256-mncs6+mGNBoZea6jPtgjFxYPbFguUne8MepxTHgsC1c=";
    };
    lispCheckDependencies = [ prove ];
  }) {};

  inherit (callPackage ({
    alexandria
    , babel
    , trivial-features
    , trivial-gray-streams
    , hu_dwim_stefil
  }:
  lispMultiDerivation {
    src = pkgs.fetchFromGitHub {
      name = "babel-src";
      owner = "cl-babel";
      repo = "babel";
      rev = "f892d0587c7f3a1e6c0899425921b48008c29ee3";
      sha256 = "sha256-U2E8u3ZWgH9eG4SV/t9CE1dUpcthuQMXgno/W1Ow2RE=";
    };

    systems = {
      babel = {
        lispDependencies = [ alexandria trivial-features ];
        lispCheckDependencies = [ hu_dwim_stefil ];
      };
      babel-streams = {
        lispDependencies = [ alexandria babel trivial-gray-streams ];
        lispCheckDependencies = [ hu_dwim_stefil ];
      };
    };
  }) {}) babel babel-streams;

  blackbird = callPackage (self: with self; lispDerivation {
    lispSystem = "blackbird";
    src = pkgs.fetchFromGitHub {
      name = "blackbird-src";
      repo = "blackbird";
      owner = "orthecreedence";
      rev = "abe3696e1a128bd082fb5d3e211f33d8feb25bc8";
      sha256 = "sha256-VBmXHK6TKNcYbCdIhVSP08E0blGVJCL9N/VPNQ5JDuQ=";
    };
    lispDependencies = [ vom ];
    lispCheckDependencies = [ cl-async fiveam ];
  }) {};

  inherit (callPackage (self: with self;
    lispMultiDerivation rec {
      name = "cffi";
      version = "v0.24.1";
      src = pkgs.fetchFromGitHub {
        name = "cffi-src";
        owner = "cffi";
        repo = "cffi";
        rev = version;
        sha256 = "sha256-QzISoQ4JpLhnxnPlSgWYE0PbSionu+b7z2HR2EmNPp8=";
      };
      patches = ./patches/clffi-libffi-no-darwin-carevout.patch;
      systems = {
        cffi = {
          lispDependencies = [ alexandria babel trivial-features ];
          lispCheckDependencies = [ cffi-grovel bordeaux-threads rt ];
          # I don’t know if cffi-libffi is external but it doesn’t seem to be
          # so just leave it for now.
        };
        cffi-grovel = {
          # cffi-grovel depends on cffi-toolchain. Just specifying it as an
          # exported system works because cffi-toolchain is specified in this
          # same source derivation.
          lispSystems = [ "cffi-grovel" "cffi-toolchain" ];
          lispDependencies = [ alexandria cffi trivial-features ];
          lispCheckDependencies = [ bordeaux-threads rt ];
        };
      };
      # lisp-modules-new doesn’t specify this and somehow it works fine. Is
      # there an accidental transitive dependency, there? Or how is this
      # solved? Additionally, this only seems to be used by a pretty
      # incidental make call, because the only rule that uses GCC just happens
      # to be at the top, making it the default make target. Not sure if this
      # is the ideal way to “build” this package.  Note: Technically this will
      # always be required because cffi-grovel depends on cffi bare, but it’s
      # a good litmus test for the system.
      nativeBuildInputs = [ pkgs.pkg-config ];
      buildInputs = systems: l.optionals (b.elem "cffi" systems) [ pkgs.gcc pkgs.libffi ];
      # This is broken on Darwin because libcffi rewrites the import path in a
      # way that’s incompatible with pkgconfig. It should be "if darwin AND (not
      # pkg-config)".
    }
  ) {}) cffi cffi-grovel;

  chipz = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "chipz-src";
    owner = "sharplispers";
    repo = "chipz";
    rev = "82a17d39c78d91f6ea63a03aca8f9aa6069a5e11";
    sha256 = "sha256-MJyhF/lPrkhTnyQdmN5enr2XERk/dG+avCoimaIQjtg=";
  })) {};

  chunga = callPackage (self: with self; lispify [ trivial-gray-streams ] (pkgs.fetchFromGitHub {
    name = "chunga-src";
    owner = "edicl";
    repo = "chunga";
    rev = "v1.1.7";
    sha256 = "sha256-DfqbKCuK4oTh1qrKHdOCdWhcdUrT5YFSfUK4sbwd9ks=";
  })) {};

  circular-streams = callPackage (self: with self; lispDerivation {
    lispSystem = "circular-streams";
    src = pkgs.fetchFromGitHub {
      name = "circular-streams-src";
      owner = "fukamachi";
      repo = "circular-streams";
      rev = "e770bade1919c5e8533dd2078c93c3d3bbeb38df";
      sha256 = "sha256-OpeLjFbiiwycwZjMeYgu7YoyFYy7HieSY9hHxkoz/PI=";
    };
    lispDependencies = [ fast-io trivial-gray-streams ];
    lispCheckDependencies = [ cl-test-more flexi-streams ];
  }) {};

  cl-annot = callPackage (self: with self; lispDerivation {
    lispSystem = "cl-annot";
    src = pkgs.fetchFromGitHub {
      name = "cl-annot-src";
      owner = "m2ym";
      repo = "cl-annot";
      rev = "c99e69c15d935eabc671b483349a406e0da9518d";
      sha256 = "sha256-lkyoenlsJLbc1etJyqTTeLcSTxPMgJ15NLU0KZN+AfM=";
    };
    lispDependencies = [ alexandria ];
    lispCheckDependencies = [ cl-test-more ];
  }) {};

  cl-ansi-text = callPackage (self: with self; lispDerivation {
    lispSystem = "cl-ansi-text";
    src = pkgs.fetchFromGitHub {
      name = "cl-ansi-text-src";
      owner = "pnathan";
      repo = "cl-ansi-text";
      rev = "v2.0.1";
      sha256 = "sha256-JChf6zT7JPpm50RjVkB1ziO+pDTI/+Fj4Gck5bBUZ1o=";
    };
    lispDependencies = [ alexandria cl-colors2 ];
    lispCheckDependencies = [ fiveam ];
  }) {};

  inherit (callPackage (self: with self; lispMultiDerivation rec {
    name = "cl-async";
    version = "909c691ec7a3bfe98bbec536ab55d7eac8990a81";

    src = pkgs.fetchFromGitHub {
      name = "cl-async-src";
      owner = "orthecreedence";
      repo = "cl-async";
      rev = version;
      sha256 = "sha256-lonRpqW51lrf0zpOstYq261m2UR1YMrgKR23kLBrhfY=";
    };

    systems = {
      cl-async = {
        name = "cl-async";
        lispDependencies = [
          babel
          bordeaux-threads
          cffi
          cffi-grovel
          cl-libuv
          cl-ppcre
          fast-io
          static-vectors
          trivial-features
          trivial-gray-streams
          vom
        ];
      };

      cl-async-repl = {
        name = "cl-async-repl";
        lispDependencies = [ bordeaux-threads cl-async ];
      };

      cl-async-ssl = {
        name = "cl-async-ssl";
        lispDependencies = [ cffi cl-async vom ];
      };
    };
  }) {}) cl-async cl-async-repl cl-async-ssl;

  cl-base64 = callPackage (self: with self; lispDerivation rec {
    lispSystem = "cl-base64";
    version = "577683b18fd880b82274d99fc96a18a710e3987a";
    src = pkgs.fetchzip {
      pname = "cl-base64-src";
      inherit version;
      url = "http://git.kpe.io/?p=cl-base64.git;a=snapshot;h=${version}";
      sha256 = "sha256-cuVDuPj8gXiN9kLgWpWerkZgodno2s3OENZoByApUoo=";
      # This is necessary because the auto generated filename for a gitweb
      # URL contains invalid characters.
      extension = "tar.gz";
    };
    lispCheckDependencies = [ ptester kmrcl ];
  }) {};

  cl-change-case = callPackage (self: with self; lispDerivation {
    lispSystem = "cl-change-case";
    src = pkgs.fetchFromGitHub {
      name = "cl-change-case-src";
      repo = "cl-change-case";
      owner = "rudolfochrist";
      rev = "0.2.0";
      sha256 = "sha256-mPRkekxFg3t6hcWkPE0TDGgj9mh/ymISDr2h+mJQAmI=";
    };
    lispDependencies = [
      cl-ppcre
      cl-ppcre-unicode
    ];
    lispCheckDependencies = [ fiveam ];
  }) {};

  bordeaux-threads = callPackage (self: with self; lispDerivation rec {
    lispDependencies = [
      alexandria
      global-vars
      trivial-features
      trivial-garbage
    ];
    lispCheckDependencies = [ fiveam ];
    buildInputs = [ pkgs.libuv ];
    lispSystem = "bordeaux-threads";
    version = "v0.8.8";
    src = pkgs.fetchFromGitHub {
      name = "bordeaux-threads-src";
      owner = "sionescu";
      repo = "bordeaux-threads";
      rev = version;
      sha256 = "sha256-5mauBDg13zJlYkbu5C30dCOIPBE95bVu2AiR8d0gJKY=";
    };
  }) {};

  cl-colors = callPackage (self: with self; lispDerivation {
    lispSystem = "cl-colors";
    lispCheckDependencies = [ lift ];
    lispDependencies = [ alexandria let-plus ];
    src = pkgs.fetchFromGitHub {
      name = "cl-colors-src";
      owner = "tpapp";
      repo = "cl-colors";
      rev = "827410584553f5c717eec6182343b7605f707f75";
      sha256 = "sha256-KvnhquSX+rXTeUuN0cKSaG93UqRy4JWqXh4Srxo1hFA=";
    };
  }) {};

  cl-colors2 = callPackage (self: with self; lispDerivation {
    lispSystem = "cl-colors2";
    src = pkgs.fetchzip rec {
      pname = "cl-colors2-src";
      version = "cc37737fc70892ed97152842fafa086ad1b7beab";
      url = "https://notabug.org/cage/cl-colors2/archive/${version}.tar.gz";
      sha256 = "sha256-GXq3Q6MjdS79EKks2ayojI+ZYh8hRVkd0TNkpjWF9zI=";
    };
    lispDependencies = [ alexandria cl-ppcre ];
    lispCheckDependencies = [ clunit2 ];
  }) {};

  cl-cookie = callPackage (self: with self; lispDerivation {
    lispSystem = "cl-cookie";
    src = pkgs.fetchFromGitHub {
      name = "cl-cookie-src";
      repo = "cl-cookie";
      owner = "fukamachi";
      rev = "e6babbf57c9c6e0b6998a5b5ecaea8fa59f88296";
      sha256 = "sha256-RBTuCVQA2DKjgznDvKRYI+TGDH1c5Xuk6LW321hVGB4=";
    };
    lispDependencies = [ alexandria cl-ppcre proc-parse local-time quri ];
    lispCheckDependencies = [ prove ];
  }) {};

  cl-coveralls = callPackage (self: with self; lispDerivation {
    lispSystem = "cl-coveralls";
    lispCheckDependencies = [ prove ];
    lispDependencies = [
      alexandria
      cl-ppcre
      dexador
      flexi-streams
      ironclad
      jonathan
      lquery
      split-sequence
    ];
    src = pkgs.fetchFromGitHub {
      name = "cl-coveralls-src";
      owner = "fukamachi";
      repo = "cl-coveralls";
      rev = "69b2f05540392f204c0312f4be356145932b2787";
      sha256 = "sha256-4LM1pMzJkvR5Uo0A6mI7iT6RR9fP+P9FXP0IJJKektg=";
    };
  }) {};

  cl-fad = callPackage (self: with self; lispDerivation {
    lispSystem = "cl-fad";
    src = pkgs.fetchFromGitHub {
      name = "cl-fad-src";
      owner = "edicl";
      repo = "cl-fad";
      rev = "v0.7.6";
      sha256 = "sha256-6m6gvc5Hgby2K5U6sVuks4qZL8mkVEvBO3o+swWKiL0=";
    };
    lispDependencies = [ alexandria bordeaux-threads ];
    lispCheckDependencies = [ cl-ppcre unit-test ];
  }) {};

  cl-interpol = callPackage (self: with self; lispDerivation {
    lispSystem = "cl-interpol";
    src = pkgs.fetchFromGitHub {
      name = "cl-interpol-src";
      owner = "edicl";
      repo = "cl-interpol";
      rev = "v0.2.7";
      sha256 = "sha256-Q45Z61BtAhaelYLrJkE2cNa/kRIQSngrrABjieO+1OQ=";
    };
    lispDependencies = [ cl-unicode named-readtables ];
    lispCheckDependencies = [ flexi-streams ];
  }) {};

  cl-isaac = callPackage (self: with self; lispDerivation {
    lispSystem = "cl-isaac";
    src = pkgs.fetchFromGitHub {
      name = "cl-isaac-src";
      owner = "thephoeron";
      repo = "cl-isaac";
      rev = "9cd88f39733be753facbf361cb0e08b9e42ff8d5";
      sha256 = "sha256-iV+7YkGPAA+e0SXODlSDAJIUUiL+pcj2ya7FHJGr4UU=";
    };
    lispCheckDependencies = [ prove ];
  }) {};

  cl-libuv = callPackage (self: with self; lispDerivation rec {
    lispDependencies = [ alexandria cffi cffi-grovel ];
    buildInputs = [ pkgs.libuv ];
    lispSystem = "cl-libuv";
    version = "ebe3e166d1b6608efdc575be55579a086356b3fc";
    src = pkgs.fetchFromGitHub {
      name = "cl-libuv-src";
      owner = "orthecreedence";
      repo = "cl-libuv";
      rev = version;
      sha256 = "sha256-sGN4sIM+yy7VXudzrU6jV/+DLEY12EOK69TXnh94rGU=";
    };
  }) {};

  cl-plus-ssl = callPackage (self: with self; lispDerivation {
    lispSystem = "cl+ssl";
    src = pkgs.fetchFromGitHub {
      name = "cl+ssl-src";
      repo = "cl-plus-ssl";
      owner = "cl-plus-ssl";
      rev = "094db34fc3dd6d3802d3665bc477b55793a2c96a";
      sha256 = "sha256-5bgiC7rtNJ17H+60GyUn1tz7WV1wtyK0RZpKFKKmrXQ=";
    };
    lispDependencies = [
      alexandria
      bordeaux-threads
      cffi
      flexi-streams
      trivial-features
      trivial-garbage
      trivial-gray-streams
      usocket
    ];
    lispCheckDependencies = [
      bordeaux-threads
      cl-coveralls
      fiveam
      trivial-sockets
      usocket
    ];
  }) {};

  inherit (callPackage (self: with self; lispMultiDerivation rec {
    version = "v2.1.1";
    src = pkgs.fetchFromGitHub {
      name = "cl-ppcre-src";
      owner = "edicl";
      repo = "cl-ppcre";
      rev = version;
      sha256 = "sha256-UffzJ2i4wpkShxAJZA8tIILUbBZzbWlseezj2JLImzc=";
    };
    systems = {
      cl-ppcre = {
        lispCheckDependencies = [ flexi-streams ];
      };
      cl-ppcre-unicode = {
        lispDependencies = [ cl-ppcre cl-unicode ];
        lispCheckDependencies = [ flexi-streams ];
      };
    };
  }) {}) cl-ppcre cl-ppcre-unicode;

  cl-speedy-queue = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "cl-speedy-queue-src";
    owner = "zkat";
    repo = "cl-speedy-queue";
    rev = "0425c7c62ad3b898a5ec58cd1b3e74f7d91eec4b";
    sha256 = "sha256-OGaqhBkHKNUwHY3FgnMbWGdsUfBn0QDTl2vTZPu28DM=";
  })) {};

  inherit (callPackage (self: with self; lispMultiDerivation {
    src = pkgs.fetchFromGitHub {
      name = "cl-syntax-src";
      owner = "m2ym";
      repo = "cl-syntax";
      rev = "03f0c329bbd55b8622c37161e6278366525e2ccc";
      sha256 = "sha256-nlD/ziiKCdFfMzcxxyE30CmeAuJo9zDoU1qdczuyKp8=";
    };

    systems = {
      cl-syntax = {
        lispDependencies = [ named-readtables trivial-types ];
      };
      cl-syntax-annot = {
        lispDependencies = [ cl-syntax cl-annot ];
      };
      cl-syntax-interpol = {
        lispDependencies = [ cl-syntax cl-interpol ];
      };
    };
  }) {}) cl-syntax cl-syntax-annot cl-syntax-interpol;

  cl-test-more = prove;

  cl-unicode = callPackage (self: with self; lispDerivation {
    lispSystem = "cl-unicode";
    src = pkgs.fetchFromGitHub {
      name = "cl-unicode-src";
      owner = "edicl";
      repo = "cl-unicode";
      rev = "v0.1.6";
      sha256 = "sha256-6kPg5c5k9KKRUZms0GRiLrQfBR0zgn7DJYc6TJMWfXo=";
    };
    lispDependencies = [ cl-ppcre flexi-streams ];
  }) {};

  cl-who = callPackage (self: with self; lispDerivation {
    lispSystem = "cl-who";
    src = pkgs.fetchFromGitHub {
      name = "cl-who-src";
      owner = "edicl";
      repo = "cl-who";
      rev = "07dafe9b351c32326ce20b5804e798f10d4f273d";
      sha256 = "sha256-5T762W3qetAjXtHP77ko6YZR6w5bQ04XM6QZPELQu+U=";
    };
    lispCheckDependencies = [ flexi-streams ];
  }) {};

  inherit (callPackage (self: with self;
    lispMultiDerivation {
      src = pkgs.fetchFromGitHub {
        name = "clack-src";
        owner = "fukamachi";
        rev = "960ab7bbe6488423892c46ee958f2fcca80fac7e";
        sha256 = "sha256-3lblQ3q8tSqKujgi9PABRXwMccke/VlCxfRA9lwP5u0=";
        repo = "clack";
      };

      systems = {
        # TODO: This is a complex package with lots of derivations and check
        # dependencies. Fill in as necessary. I’ve only filled in what I need
        # right now.
        clack = {
          lispDependencies = [
            alexandria
            bordeaux-threads
            lack
            lack-middleware-backtrace
            lack-util
            swank
            usocket
          ];
        };
        clack-handler-hunchentoot = {
          lispDependencies = [
            alexandria
            bordeaux-threads
            clack-socket
            flexi-streams
            hunchentoot
            split-sequence
          ];
          lispCheckDependencies = [ clack-test ];
        };
        clack-socket = {};
        clack-test = {
          lispDependencies = [
            bordeaux-threads
            clack
            clack-handler-hunchentoot
            dexador
            flexi-streams
            http-body
            ironclad
            rove
            usocket
          ];
        };
      };
    }) {}) clack clack-handler-hunchentoot clack-socket clack-test;

  # The official location for this source is
  # "https://www.common-lisp.net/project/cl-utilities/cl-utilities-latest.tar.gz"
  # but I’m not a huge fan of including a "latest.tar.gz" in a Nix
  # derivation. That being said: it hasn’t been changed since 2006, so maybe
  # that is a better resource.
  cl-utilities = callPackage (self: with self; lispDerivation {
    lispSystem = "cl-utilities";
    src = fetchDebianPkg {
      pname = "cl-utilities";
      version = "1.2.4";
      sha256 = "sha256-/CAF/qaLjd3t9P+0eSGoC18f3MJT1dB94VLUjnKbq7Y";
    };
  }) {};

  closer-mop = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "closer-mop-src";
    repo = "closer-mop";
    owner = "pcostanza";
    rev = "60d05d6057bd2c8f37790989ffe2a2676c179f23";
    sha256 = "sha256-pOFP68j1P/vxilTNV7P2EqzDtk8qG4OrLuLszcIGdpU=";
  })) {};

  clss = callPackage (self: with self; lispify [ array-utils plump ] (pkgs.fetchFromGitHub {
    name = "clss-src";
    repo = "clss";
    owner = "Shinmera";
    rev = "f62b849189c5d1be378f0bd3d403cda8d4fe310b";
    sha256 = "sha256-24XWonW5plv83h9Sule6q6nEFUAZOlxofwxadSFrY4A=";
  })) {};

  clunit2 = callPackage (self: with self; lispify [ ] (pkgs.fetchzip rec {
    pname = "clunit2-src";
    version = "200839e8e47e9212ded2d36520d84b9be681037c";
    url = "https://notabug.org/cage/clunit2/archive/${version}.tar.gz";
    sha256 = "sha256-5Pud/s5LywqrY+EjDG2iCtuuildTzfDmVYzqhnJ5iyQ=";
  })) {};

  colorize = callPackage (self: with self; lispify [ alexandria html-encode split-sequence ] (pkgs.fetchFromGitHub {
    name = "colorize-src";
    repo = "colorize";
    owner = "kingcons";
    rev = "ea676b584e0899cec82f21a9e6871172fe3c0eb5";
    sha256 = "sha256-ibMfRqzw8Q28UrAdm4/AIS866rk5Qud2HLl+puIkr90=";
  })) {};

  dexador = callPackage (self: with self; lispDerivation {
    lispSystem = "dexador";
    src = pkgs.fetchFromGitHub {
      name = "dexador-src";
      repo = "dexador";
      owner = "fukamachi";
      rev = "2a095bf7b2d59905b242f81b0bfa57d63d5ac23a";
      sha256 = "sha256-yS+MNmLQuCwf2HmOZZYJU/D3XvPHkN321r+/L0SY4c8=";
    };
    lispDependencies = [
      alexandria
      babel
      bordeaux-threads
      chipz
      chunga
      cl-base64
      cl-cookie
      cl-plus-ssl
      cl-ppcre
      fast-http
      fast-io
      quri
      trivial-garbage
      trivial-gray-streams
      trivial-mimes
      usocket
    ] ++ lib.optional pkgs.hostPlatform.isWindows flexi-streams;
    lispCheckDependencies = [
      babel
      cl-cookie
      clack-test
      lack-request
      rove
    ];
  }) {};

  # TODO: if clisp, then depend on cl-ppcre
  dissect = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "dissect-src";
    owner = "Shinmera";
    repo = "dissect";
    rev = "6c15c887a8d3db2ce83037ff31f8a0b528aa446b";
    sha256 = "sha256-px1DT8MRzeqEwsV/sJBJHrlsHrWEDQopfGzuHc+QqoE=";
  })) {};

  documentation-utils = callPackage (self: with self; lispDerivation {
    lispSystem = "documentation-utils";
    src = pkgs.fetchFromGitHub {
      name = "documentation-utils-src";
      repo = "documentation-utils";
      owner = "Shinmera";
      rev = "98630dd5f7e36ae057fa09da3523f42ccb5d1f55";
      sha256 = "sha256-uMUyzymyS19ODiUjQbE/iJV7HFeVjB45gbnWqfGEGCU=";
    };
    lispDependencies = [ trivial-indent ];
  }) {};

  drakma = callPackage (self: with self; lispDerivation {
    lispSystem = "drakma";
    src = pkgs.fetchFromGitHub {
      name = "drakma-src";
      owner = "edicl";
      repo = "drakma";
      rev = "v2.0.9";
      sha256 = "sha256-sKrtgEH65Vps/27GKgXjHBMI0OJgmgxg5Tg3lHNyufg=";
    };
    lispDependencies = [
      chipz
      chunga
      cl-base64
      cl-plus-ssl
      cl-ppcre
      flexi-streams
      puri
      usocket
    ];
    lispCheckDependencies = [ fiveam ];
  }) {};

  eos = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "eos-src";
    owner = "adlai";
    repo = "Eos";
    rev = "b4413bccc4d142cbe1bf49516c3a0a22c9d99243";
    sha256 = "sha256-E9p5yKay3nyGWxmOeQTpfA51B2X+EUD+9yd1S+um1Kk=";
  })) {};

  esrap = callPackage (self: with self; lispDerivation {
    lispSystem = "esrap";
    src = pkgs.fetchFromGitHub {
      name = "esrap-src";
      owner = "scymtym";
      repo = "esrap";
      rev = "7588b430ad7c52f91a119b4b1c9a549d584b7064";
      sha256 = "sha256-C0GiTyRna9BMIMy1/XdMZAkhjpLaoAEF1+ps97xQyMY=";
    };
    lispDependencies = [ alexandria trivial-with-current-source-form ];
    lispCheckDependencies = [ fiveam ];
  }) {};

  fast-http = callPackage (self: with self; lispDerivation {
    src = pkgs.fetchFromGitHub {
      name = "fast-http-src";
      repo = "fast-http";
      owner = "fukamachi";
      rev = "502a37715dcb8544cc8528b78143a942de662c5a";
      sha256 = "sha256-sZo0osVlmeOwFfoVrYrvTL1L47pDrOO0pFKmIN55gio=";
    };
    lispSystem = "fast-http";
    lispDependencies = [
      alexandria
      babel
      cl-utilities
      log4cl
      proc-parse
      smart-buffer
      xsubseq
    ];
    lispCheckDependencies = [
      babel
      cl-syntax-interpol
      prove
      xsubseq
    ];
  }) {};

  fast-io = callPackage (self: with self; lispify [
    alexandria
    static-vectors
    trivial-gray-streams
  ] (pkgs.fetchFromGitHub {
    name = "fast-io-src";
    owner = "rpav";
    repo = "fast-io";
    rev = "a4c5ad600425842e8b6233b1fa22610ffcd874c3";
    sha256 = "sha256-YBTROnJyB8w3H+GDhlHI+6n7XvnyoGN+8lDh9ZQXAHI=";
  })) {};

  fare-mop = callPackage (self: with self; lispify [
    closer-mop
    fare-utils
  ] (pkgs.fetchFromGitHub {
    name = "fare-mop-src";
    owner = "fare";
    repo = "fare-mop";
    rev = "538aa94590a0354f382eddd9238934763434af30";
    sha256 = "sha256-LGx/Te7RgHr9zuSRe2OXHa5WRbX8G6UsdKMkkQbSXVU=";
  })) {};

  inherit (callPackage (self: with self; lispMultiDerivation {
    src = pkgs.fetchFromGitHub {
      name = "fare-quasiquote-src";
      owner = "fare";
      repo = "fare-quasiquote";
      rev = "ccb0285b456c4d6bb09b9f931cf0ac5e72353ae5";
      sha256 = "sha256-9tCP0IqU4TDmt0sUb3oJgTVC2DlfI4y7LdhsCfrglQw=";
    };
    systems = {
      fare-quasiquote = {
        lispDependencies = [ fare-utils ];
        lispCheckDependencies = [
          fare-quasiquote-extras
          hu_dwim_stefil
          optima
        ];
      };
      fare-quasiquote-extras = {
        lispDependencies = [
          fare-quasiquote-optima
          fare-quasiquote-readtable
        ];
      };
      fare-quasiquote-optima = {
        lispDependencies = [
          trivia-quasiquote
        ];
      };
      fare-quasiquote-readtable = {
        lispDependencies = [ fare-quasiquote named-readtables ];
      };
    };
  }) {}) fare-quasiquote
         fare-quasiquote-extras
         fare-quasiquote-optima
         fare-quasiquote-readtable;

  fare-utils = callPackage (self: with self; lispDerivation {
    lispSystem = "fare-utils";
    # While the PR to fix the test .asd is pending, point at my fork
    src = pkgs.fetchFromGitHub {
      name = "fare-utils-src";
      owner = "hraban";
      repo = "fare-utils";
      rev = "8bf19331fc541e4fb40b55ae9747d774eb427828";
      sha256 = "sha256-Eye1XJUNWhptVlkukrwVmYL9dKpyrn8PJEdMDPntYzw=";
    };
    lispCheckDependencies = [ hu_dwim_stefil ];
  }) {};

  fiveam = callPackage (self: with self; lispify [ alexandria asdf-flv trivial-backtrace ] (pkgs.fetchFromGitHub {
    name = "fiveam-src";
    owner = "lispci";
    repo = "fiveam";
    rev = "v1.4.2";
    sha256 = "sha256-ktwyRdDG3Z0KOnM0C8lbq7ZAZVqozTbwkiUsWuktsBI=";
  })) {};

  flexi-streams = callPackage (self: with self; lispify [ trivial-gray-streams ] (pkgs.fetchFromGitHub {
    name = "flexi-streams-src";
    owner = "edicl";
    repo = "flexi-streams";
    rev = "v1.0.19";
    sha256 = "sha256-4GRKx0BrVtO6CjsSEal2/MzeXK+bel5J++w3mi2B9Gw=";
  })) {};

  form-fiddle = callPackage (self: with self; lispDerivation {
    lispSystem = "form-fiddle";
    src = pkgs.fetchFromGitHub {
      name = "form-fiddle-src";
      repo = "form-fiddle";
      owner = "Shinmera";
      rev = "e0c23599dbb8cff3e83e012f3d86d0764188ad18";
      sha256 = "sha256-lsqBiHT6nYizomy8ZNe+Yq2btB8Jla0Bzd7dmpj9MRA=";
    };
    lispDependencies = [ documentation-utils ];
  }) {};

  fset = callPackage (self: with self; lispify [ misc-extensions mt19937 named-readtables ] (pkgs.fetchFromGitHub {
    name = "fset-src";
    owner = "slburson";
    repo = "fset";
    rev = "69c209e6eb15187da04f70ece3f800a6e3cc8639";
    sha256 = "sha256-XqPr1MK8rZvz+f+cumVoX/RynfMhsJnXhrSBxZQqSJQ=";
  })) {};

  global-vars = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "global-vars-src";
    owner = "lmj";
    repo = "global-vars";
    rev = "c749f32c9b606a1457daa47d59630708ac0c266e";
    sha256 = "sha256-bXxeNNnFsGbgP/any8rR3xBvHE9Rb4foVfrdQRHroxo=";
  })) {};

  html-encode = callPackage (self: with self; lispify [ ] (pkgs.fetchzip rec {
    pname = "html-encode-src";
    version = "1.2";
    url = "http://beta.quicklisp.org/orphans/html-encode-${version}.tgz";
    sha256 = "sha256-qw2CstJIDteQC4N1eQEsD9+HRm1i9GP/XjjIZXtZr/k=";
  })) {};

  http-body = callPackage (self: with self; lispDerivation {
    lispSystem = "http-body";
    src = pkgs.fetchFromGitHub {
      name = "http-body-src";
      owner = "fukamachi";
      repo = "http-body";
      rev = "3e4bedd6a9d9bc4e1dc0a45e5b55360ae30fd388";
      sha256 = "sha256-4n/aq/OntjQEzSaJTl8Rv8QJMBpJstTiz40cU+ggj00=";
    };
    lispDependencies = [
      babel
      cl-ppcre
      cl-utilities
      fast-http
      flexi-streams
      jonathan
      quri
      trivial-gray-streams
    ];
    lispCheckDependencies = [
      assoc-utils
      cl-ppcre
      flexi-streams
      prove
      trivial-utf-8
    ];
  }) {};

  hu_dwim_asdf = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "hu.dwim.asdf-src";
    owner = "hu-dwim";
    repo = "hu.dwim.asdf";
    rev = "2017-04-07";
    sha256 = "sha256-7U72ZSEtUZc0HSFhq6tRQP5RRxxzpe2NXaUND/UEbS0=";
  })) {};

  hu_dwim_stefil = callPackage (self: with self; lispify [ alexandria hu_dwim_asdf ] (pkgs.fetchFromGitHub {
    name = "hu.dwim.stefil-src";
    owner = "hu-dwim";
    repo = "hu.dwim.stefil";
    rev = "2017-04-07";
    sha256 = "sha256-Ka3OO+cyafx0bcM9bdhZN2pHWjnVq116bU1mPS3ClSQ=";
  })) {};

  hunchentoot = callPackage (self: with self; lispDerivation {
    lispSystem = "hunchentoot";
    src = pkgs.fetchFromGitHub {
      name = "hunchentoot-src";
      owner = "edicl";
      repo = "hunchentoot";
      rev = "v1.3.0";
      sha256 = "sha256-ydfIWhBVRTvfBjHejyGVdYk28JCPEJrMS2Vnc2khFfw=";
    };
    lispDependencies = [
      alexandria
      chunga
      cl-base64
      cl-fad
      cl-ppcre
      flexi-streams
      md5
      rfc2388
      trivial-backtrace
      # TODO: Per-lisp selection (these are not necessary on lispworks)
      cl-plus-ssl
      usocket
      bordeaux-threads
    ];
    lispCheckDependencies = [
      cl-ppcre
      cl-who
      drakma
    ];
  }) {};

  ieee-floats = callPackage (self: with self; lispDerivation {
    lispSystem = "ieee-floats";
    src = pkgs.fetchFromGitHub {
      name = "ieee-floats-src";
      owner = "marijnh";
      repo = "ieee-floats";
      rev = "9566ce8adfb299faef803d95736c780413a1373c";
      sha256 = "sha256-7fD+0p1MunjjZ3GJANypsufM2XYAWsSqk81+mXBv4mI=";
    };
    lispCheckDependencies = [ fiveam ];
  }) {};

  inferior-shell = callPackage (self: with self; lispDerivation {
    lispSystem = "inferior-shell";
    lispDependencies = [
      alexandria
      fare-utils
      fare-quasiquote-extras
      fare-mop
      trivia
      trivia-quasiquote
    ];
    lispCheckDependencies = [ hu_dwim_stefil ];
    src = pkgs.fetchFromGitHub {
      name = "inferior-shell-src";
      owner = "fare";
      repo = "inferior-shell";
      rev = "15c2d04a7398db965ea1c3ba2d49efa7c851f2c2";
      sha256 = "sha256-lUj2tqRhmXWwgK3Qio1U+9vNhcJingN57USW+f8ZHQs=";
    };
  }) {};

  introspect-environment = callPackage (self: with self; lispDerivation {
    lispSystem = "introspect-environment";
    lispCheckDependencies = [ fiveam ];
    src = pkgs.fetchFromGitHub {
      name = "introspect-environment-src";
      owner = "Bike";
      repo = "introspect-environment";
      rev = "8fb20a1a33d29637a22943243d1482a20c32d6ae";
      sha256 = "sha256-Os0XnUtgq+zqpPT9UyLecXEHSVY+MsCTKIfUGLKViNw=";
    };
  }) {};

  ironclad = callPackage (self: with self; lispDerivation {
    lispSystem = "ironclad";
    src = pkgs.fetchFromGitHub {
      name = "ironclad-src";
      owner = "sharplispers";
      repo = "ironclad";
      rev = "v0.58";
      sha256 = "sha256-KCLl7zcnpapHZoPQcxTWeorQE5Hat1jPK4IET4J69J4=";
    };
    lispDependencies = [ bordeaux-threads ];
    lispCheckDependencies = [ rt ];
  }) {};

  iterate = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitLab {
    name = "iterate-src";
    domain = "gitlab.common-lisp.net";
    owner = "iterate";
    repo = "iterate";
    rev = "1.5.3";
    sha256 = "sha256-giEXCF+9q5fcCmE3Q6NDCq+rV6+qcglArJdf9q5D1FA=";
  })) {};

  puri = callPackage (self: with self; lispDerivation {
    lispSystem = "puri";
    src = pkgs.fetchFromGitLab {
      name = "puri-src";
      domain = "gitlab.common-lisp.net";
      owner = "clpm";
      repo = "puri";
      rev = "4bbab89d9ccbb26346899d1f496c97604fec567b";
      sha256 = "sha256-rV5ViV0082r3PQlmUdYo+GtCW934kw3EBxpGBbLOAj8=";
    };
    lispCheckDependencies = [ ptester ];
  }) {};

  jonathan = callPackage (self: with self; lispDerivation {
    lispSystem = "jonathan";
    src = pkgs.fetchFromGitHub {
      name = "jonathan-src";
      owner = "Rudolph-Miller";
      repo = "jonathan";
      rev = "fb83ff094d330b2208b0febc8b25983c6050e378";
      sha256 = "sha256-z+p8Hj1eAS148KomWkX5yPvAqf4zfr3m1ivKWF13mtA=";
    };
    lispDependencies = [
      babel
      cl-annot
      cl-ppcre
      cl-syntax
      cl-syntax-annot
      fast-io
      proc-parse
      trivial-types
    ];
    lispCheckDependencies = [
      prove
      legion
    ];
  }) {};

  kmrcl = callPackage (self: with self; lispDerivation rec {
    lispSystem = "kmrcl";
    version = "4a27407aad9deb607ffb8847630cde3d041ea25a";
    src = pkgs.fetchzip {
      pname = "kmrcl-src";
      inherit version;
      url = "http://git.kpe.io/?p=kmrcl.git;a=snapshot;h=${version}";
      sha256 = "sha256-oq28Xy1NrL/v4cipw4sObu3YkDBIAo0OR8wWqCoB/Rk=";
      # This is necessary because the auto generated filename for a gitweb
      # URL contains invalid characters.
      extension = "tar.gz";
    };
    lispCheckDependencies = [ rt ];
  }) {};

  inherit (callPackage (self: with self;
    lispMultiDerivation {
      src = pkgs.fetchFromGitHub {
        repo = "lack";
        owner = "fukamachi";
        name = "lack-src";
        rev = "22b37656799f534286f5c645602358bdcc7c1803";
        sha256 = "sha256-XCbaAqZhyBd9h6clFbQPV2QdlfdQBmfGE43dkDv5pXs=";
      };
      systems = {
        lack = {
          lispDependencies = [ lack-util ];
          lispCheckDependencies = [ clack prove ];
        };

        lack-middleware-backtrace = {
          lispCheckDependencies = [ alexandria lack prove ];
        };

        lack-request = {
          lispDependencies = [
            circular-streams
            cl-ppcre
            http-body
            quri
          ];
          lispCheckDependencies = [
            alexandria
            clack-test
            dexador
            flexi-streams
            hunchentoot
            prove
          ];
        };

        # stand-alone project used as a dependency of help systems
        lack-test = {
          lispDependencies = [
            bordeaux-threads
            clack
            clack-handler-hunchentoot
            dexador
            flexi-streams
            http-body
            ironclad
            rove
            usocket
          ];
        };

        lack-util = {
          lispDependencies =
            if pkgs.hostPlatform.isWindows
            then [ ironclad ]
            else [ cl-isaac ];
          lispCheckDependencies = [ lack-test prove ];
        };
      };
    }) {}) lack
           lack-middleware-backtrace
           lack-request
           lack-test
           lack-util;

  legion = callPackage (self: with self; lispDerivation {
    lispSystem = "legion";
    src = pkgs.fetchFromGitHub {
      name = "legion-src";
      owner = "fukamachi";
      repo = "legion";
      rev = "599cca19f0e34246814621f7fe90322221c2e263";
      sha256 = "sha256-JmrSMxvpud5vQ3AFiwRGdDrOPs1dcEFkI20hVwG/AxU=";
    };
    lispDependencies = [
      vom
      # Not listed in the .asd but these are required
      bordeaux-threads
      cl-speedy-queue
    ];
    lispCheckDependencies = [ local-time prove ];
  }) {};

  let-plus = callPackage (self: with self; lispDerivation {
    lispSystem = "let-plus";
    lispCheckDependencies = [ lift ];
    lispDependencies = [ alexandria anaphora ];
    src = pkgs.fetchFromGitHub {
      name = "let-plus-src";
      owner = "tpapp";
      repo = "let-plus";
      rev = "7cf18b29ed0fe9c667a9a6a101b08ab9661a59e9";
      sha256 = "sha256-DhRC8uN5Aq5hAy0wJnuu+ktSX1RSQFXHmK1J3gpYw/c=";
    };
  }) {};

  lift = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "lift-src";
    owner = "gwkkwg";
    repo = "lift";
    rev = "074601e7e18ebeb4fb9547eff70b52337ab18310";
    sha256 = "sha256-3WCwYgXQJ4mHyZrTtiKq2Bwiue1HJ/O3zYjj6QyxI5Q=";
  })) {};

  lisp-namespace = callPackage (self: with self; lispDerivation {
    lispSystem = "lisp-namespace";
    lispDependencies = [ alexandria ];
    lispCheckDependencies = [ fiveam ];
    src = pkgs.fetchFromGitHub {
      name = "lisp-namespace-src";
      owner = "guicho271828";
      repo = "lisp-namespace";
      rev = "699fccb6727027343bb5fca69162a3113996edfc";
      sha256 = "sha256-1/Sl03Kid+KgrQVYYwRvOU9XuFRo0Bv8VZCTpWpardw=";
    };
  }) {};

  local-time = callPackage (self: with self; lispDerivation {
    lispSystem = "local-time";
    src = pkgs.fetchFromGitHub {
      name = "local-time-src";
      rev = "40169fe26d9639f3d9560ec0255789bf00b30036";
      repo = "local-time";
      owner = "dlowe-net";
      sha256 = "sha256-TwrL74zNmYA+gw1c4DcvSET6cL/mzOIq1P/jWf8Yd7U=";
    };
    lispCheckDependencies = [ hu_dwim_stefil ];
  }) {};

  log4cl = callPackage (self: with self; lispDerivation {
    lispSystem = "log4cl";
    src = pkgs.fetchFromGitHub {
      name = "log4cl-src";
      owner = "sharplispers";
      repo = "log4cl";
      rev = "75c4184fe3dbd7dec2ca590e5f0176de8ead7911";
      sha256 = "sha256-JUL1C029kOrlOO6RW3n82kDhMY3KNiwPsrvrOTjhU1Y=";
    };
    lispDependencies = [ bordeaux-threads ];
    lispCheckDependencies = [ stefil ];
  }) {};

  lquery = callPackage (self: with self; lispDerivation {
    lispSystem = "lquery";
    src = pkgs.fetchFromGitHub {
      owner = "Shinmera";
      repo = "lquery";
      name = "lquery-src";
      rev = "3e3a3c6b36183b63a3f473cb1fb30da9f775a078";
      sha256 = "sha256-X9ZNS8QNSlED2Fe/AX8A4yW4g4imrqwijgOItQYx164=";
    };
    lispCheckDependencies = [ fiveam ];
    lispDependencies = [ array-utils form-fiddle plump clss ];
  }) {};

  md5 = callPackage (self: with self; lispify [ flexi-streams ] (pkgs.fetchFromGitHub {
    name = "md5-src";
    owner = "pmai";
    repo = "md5";
    rev = "release-2.0.5";
    sha256 = "sha256-BY+ui/h01KrJ5VdsUfQBQvAaxJm00oo+An5YmM21QLw=";
  })) {};

  metabang-bind = callPackage (self: with self; lispDerivation {
    lispSystem = "metabang-bind";
    src = pkgs.fetchFromGitHub {
      name = "metabang-bind-src";
      owner = "gwkkwg";
      repo = "metabang-bind";
      rev = "9ab6e64a30261df109549d21ee7940df87db66bb";
      sha256 = "sha256-ed01iQytK5lp41aBBGa5bKB5S90BKgF6G5wgIMWlARk=";
    };
    lispCheckDependencies = [ lift ];
  }) {};

  mgl-pax = callPackage (self: with self; lispDerivation {
    lispSystem = "mgl-pax";
    src = pkgs.fetchFromGitHub {
      name = "mgl-pax-src";
      rev = "291b513193540ab8e328c919e5e9126a483e52cc";
      sha256 = "sha256-rLg396GcqtGDJmP6D++7BqTqGMV48YjhUZ35Wiiw6+4=";
      owner = "melisgl";
      repo = "mgl-pax";
    };
    lispDependencies = [ named-readtables pythonic-string-reader ];
    # This package is more complicated than this suggests
    lispCheckDependencies = [
      # mgl-pax/document
      _3bmd
      _3bmd-ext-code-blocks
      colorize
      md5
      try
      # mgl-pax/navigate
      swank
      # mgl-pax/transcribe
      alexandria
    ];
  }) {};

  misc-extensions = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitLab {
    name = "misc-extensions-src";
    domain = "gitlab.common-lisp.net";
    owner = "misc-extensions";
    repo = "devel";
    rev = "101c05112bf2f1e1bbf527396822d2f50ca6327a";
    sha256 = "sha256-YHt/r4deJnsr4oRTiDiTnNRkBYy0OKu7pfFjcC5x5T8=";
  })) {};

  mt19937 = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitLab {
    name = "mt19937-src";
    domain = "gitlab.common-lisp.net";
    owner = "nyxt";
    repo = "mt19937";
    rev = "831284f0c7fbda54ddfd135eee1e80afad7cc16e";
    sha256 = "sha256-j3YzNAJODcJR4nsp7Myl1K7889Kg3ojMAuYwZq3WAkA=";
  })) {};

  named-readtables = callPackage (self: with self; lispDerivation {
    lispSystem = "named-readtables";
    src = pkgs.fetchFromGitHub {
      name = "named-readtables-src";
      repo = "named-readtables";
      owner = "melisgl";
      rev = "d5ff162ce02035ec7de1acc9721385f325e928c0";
      sha256 = "sha256-25eO3gnvP52mUvjdzHn/DoPwdwhbdXsn8FvV9bnvzz0=";
    };
    lispCheckDependencies = [ try ];
  }) {};

  inherit (callPackage (self: with self; lispMultiDerivation {
    src = pkgs.fetchFromGitHub {
      repo = "optima";
      owner = "m2ym";
      name = "optima-src";
      rev = "373b245b928c1a5cce91a6cb5bfe5dd77eb36195";
      sha256 = "sha256-VDUL5bTL+987bjOiNlNFg4P9OlZj7TkFGQnpenD1hPs=";
    };
    systems = {
      optima = {
        lispCheckDependencies = [ eos optima-ppcre ];
        lispDependencies = [ alexandria closer-mop ];
      };
      optima-ppcre = {
        lispSystem = "optima.ppcre";
        lispDependencies = [ optima alexandria cl-ppcre ];
      };
    };
  }) {}) optima optima-ppcre;

  parachute = callPackage (self: with self; lispify [ documentation-utils form-fiddle trivial-custom-debugger ] (pkgs.fetchFromGitHub {
    owner = "Shinmera";
    repo = "parachute";
    name = "parachute-src";
    rev = "8bc3e1b5a1808341967aeb89516f9fab23cd1d9e";
    sha256 = "sha256-pZSyJ/CI80gZ/zX9k5XlfgCp6cewRT5ffxP3dHW49zI=";
  })) {};

  plump = callPackage (self: with self; lispify [ array-utils documentation-utils ] (pkgs.fetchFromGitHub {
    owner = "Shinmera";
    repo = "plump";
    name = "plump-src";
    rev = "cf3633d812845c2f54bb559312e5b24b7fe73abc";
    sha256 = "sha256-McmssiqmYhNp+o3qlpCljw3anKvZU2LWJjQf0WnPxVY=";
  })) {};

  proc-parse = callPackage (self: with self; lispDerivation {
    lispSystem = "proc-parse";
    lispDependencies = [ alexandria babel ];
    lispCheckDependencies = [ prove ];
    src = pkgs.fetchFromGitHub {
      owner = "fukamachi";
      repo = "proc-parse";
      name = "proc-parse-src";
      rev = "3afe2b76f42f481f44a0a495256f7abeb69cef27";
      sha256 = "sha256-gpNY32YrKMp86FhWRZHSTeckmPJYV1UZ5Z5gt4yQax8=";
    };
  }) {};

  prove = callPackage (self: with self; lispDerivation {
    # Old name for this project
    lispSystems = [ "prove" "cl-test-more" ];
    src = pkgs.fetchFromGitHub {
      name = "prove-src";
      repo = "prove";
      owner = "fukamachi";
      rev = "5d71f02795b89e36f34e8c7d50e69b67ec6ca2de";
      sha256 = "sha256-7H6JEkp9tD4bsQr2gOp4EETylja109TUwJNV+IeCRjE=";
    };
    lispDependencies = [
      alexandria
      cl-ansi-text
      cl-colors
      cl-ppcre
    ];
    lispCheckDependencies = [ alexandria split-sequence ];
  }) {};

  ptester = callPackage (self: with self; lispDerivation rec {
    lispSystem = "ptester";
    version = "20160829.gitfe69fde";
    src = fetchDebianPkg {
      inherit version;
      sha256 = "sha256-jjc7JP+T7jrbSsPU+RNhQrxOKYkQDfiJwyLbxg51FNA=";
      pname = "cl-ptester";
    };
  }) {};

  pythonic-string-reader = callPackage (self: with self; lispify [ named-readtables ] (pkgs.fetchFromGitHub {
    name = "pythonic-string-reader-src";
    repo = "pythonic-string-reader";
    owner = "smithzvk";
    sha256 = "sha256-cuBcaLKD1lv8c2NELdJMg9Vnc0a/Tsa1GVB3xLHPsaw=";
    rev = "47a70ba1e32362e03dad6ef8e6f36180b560f86a";
  })) {};

  quri = callPackage (self: with self; lispDerivation {
    lispSystem = "quri";
    lispDependencies = [ alexandria babel cl-utilities split-sequence ];
    lispCheckDependencies = [ prove ];
    src = pkgs.fetchFromGitHub {
      name = "quri-src";
      repo = "quri";
      owner = "fukamachi";
      rev = "0.6.0";
      sha256 = "sha256-nET11vDMR08TztEA+hYk4u0rHtnLQTh8gZeSPOSCOfM=";
    };
  }) {};

  rfc2388 = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitLab {
    name = "rfc2388-src";
    domain = "gitlab.common-lisp.net";
    owner = "rfc2388";
    repo = "rfc2388";
    rev = "51bf93e91cb6c2d515c7674db19cc87d4550fd0b";
    sha256 = "sha256-RqFzdYyAEvJZKcSjSNXHog2KYxxFmyHupiX2DphUV4U=";
  })) {};

  # For some reason none of these dependencies are specified in the .asd
  rove = callPackage (self: with self; lispify [
    bordeaux-threads
    dissect
    trivial-gray-streams
  ] (pkgs.fetchFromGitHub {
    name = "rove-src";
    owner = "fukamachi";
    repo = "rove";
    rev = "0.10.0";
    sha256 = "sha256-frJlBDdnoJjhKwqas/3zq414xQULCeN4XtzpgJL44ek=";
  })) {};

  rt = callPackage (self: with self; lispDerivation rec {
    lispSystem = "rt";
    version = "a6a7503a0b47953bc7579c90f02a6dba1f6e4c5a";
    src = pkgs.fetchzip {
      pname = "rt-src";
      inherit version;
      url = "http://git.kpe.io/?p=rt.git;a=snapshot;h=${version}";
      sha256 = "sha256-KxlltS8zCpuYX6Yp05eC2t/eWcTavD0XyOsp1XMWUY8=";
      # This is necessary because the auto generated filename for a gitweb
      # URL contains invalid characters.
      extension = "tar.gz";
    };
  }) {};

  smart-buffer = callPackage (self: with self; lispDerivation {
    lispSystem = "smart-buffer";
    src = pkgs.fetchFromGitHub {
      name = "smart-buffer-src";
      owner = "fukamachi";
      repo = "smart-buffer";
      rev = "619759d8a6f821773bbc65c0bda553d30e51e6f3";
      sha256 = "sha256-+d58K2b6y8umupE3Yw9Hxw/DqEG6R/EeVqeGdFQwPuU=";
    };
    lispCheckDependencies = [ babel prove ];
    lispDependencies = [ flexi-streams xsubseq ];
  }) {};

  split-sequence = callPackage (self: with self; lispDerivation {
    lispSystem = "split-sequence";
    lispCheckDependencies = [ fiveam ];
    src = pkgs.fetchFromGitHub {
      name = "split-sequence-src";
      owner = "sharplispers";
      repo = "split-sequence";
      rev = "89a10b4d697f03eb32ade3c373c4fd69800a841a";
      sha256 = "sha256-faF2EiQ+xXWHX9JlZ187xR2mWhdOYCpb4EZCPNoZ9uQ=";
    };
  }) {};

  # N.B.: Soon won’t depend on cffi-grovel
  static-vectors = callPackage (self: with self; lispDerivation {
    lispSystem = "static-vectors";
    src = pkgs.fetchFromGitHub {
      name = "static-vectors-src";
      owner = "sionescu";
      repo = "static-vectors";
      rev = "v1.8.9";
      sha256 = "sha256-3BGtfPZH4qJKrZ6tJxf18QMbkn4qEofD198qSIFQOB0=";
    };
    lispDependencies = [ alexandria cffi cffi-grovel ];
    lispCheckDependencies = [ fiveam ];
  }) {};

  stefil = callPackage (self: with self; lispify [
    alexandria
    iterate
    metabang-bind
    swank
  ] (pkgs.fetchFromGitLab {
    domain = "gitlab.common-lisp.net";
    name = "stefil-src";
    owner = "stefil";
    repo = "stefil";
    rev = "0398548ec95dceb50fc2c2c03e5fb0ce49b86c7a";
    sha256 = "sha256-kLKFBG6ZD3cRQAHoLAgxqp2fd9XaY/9DcvB/LTAxHy8=";
  })) {};

  str = callPackage (self: with self; lispDerivation {
    lispSystem = "str";
    src = pkgs.fetchFromGitHub {
      name = "str-src";
      repo = "cl-str";
      owner = "vindarel";
      rev = "0.19";
      sha256 = "sha256-aSAsXx30wFbBFIHjZioiKpZ/UAX7HsQJdYYfC6VQ38s=";
    };
    lispDependencies = [
      cl-change-case
      cl-ppcre
      cl-ppcre-unicode
    ];
    lispCheckDependencies = [ prove ];
  }) {};

  swank = callPackage (self: with self; lispDerivation {
    lispSystem = "swank";
    # The Swank Lisp system is bundled with SLIME
    src = pkgs.fetchFromGitHub {
      name = "slime-src";
      owner = "slime";
      repo = "slime";
      rev = "v2.27";
      sha256 = "sha256-FUXICb0X9z7bDIewE3b2HljzheJAugAiT4pxmoY+OHM=";
    };
    patches = ./patches/slime-fix-swank-loader-fasl-cache-pwd.diff;
  }) {};

  inherit (callPackage (self: with self; lispMultiDerivation {
    src = pkgs.fetchFromGitHub {
      name = "trivia-src";
      owner = "guicho271828";
      repo = "trivia";
      rev = "6ead14c6140d3bc9dbddcbec80195358a68c518e";
      sha256 = "sha256-G6o0ZUAAhpTFMVQL1382LQ8kOrX9kOpIAWsMJA+1GHA=";
    };

    systems = {
      trivia = {
        lispDependencies = [
          alexandria
          iterate
          trivia-trivial
          type-i
        ];
        lispCheckDependencies = [
          fiveam
          optima
          trivia-cffi
          trivia-fset
          trivia-ppcre
          trivia-quasiquote
        ];
      };

      trivia-cffi = {
        lispSystem = "trivia.cffi";
        lispDependencies = [
          cffi
          trivia-trivial
        ];
      };

      trivia-fset = {
        lispSystem = "trivia.fset";
        lispDependencies = [
          fset
          trivia-trivial
        ];
      };

      trivia-ppcre = {
        lispSystem = "trivia.ppcre";
        lispDependencies = [
          cl-ppcre
          trivia-trivial
        ];
      };

      trivia-quasiquote = {
        lispSystem = "trivia.quasiquote";
        lispDependencies = [
          fare-quasiquote-readtable
          trivia
        ];
      };

      trivia-trivial = {
        lispSystem = "trivia.trivial";
        lispDependencies = [
          alexandria
          closer-mop
          lisp-namespace
          trivial-cltl2
        ];
      };
    };
  }) {}) trivia
         trivia-cffi
         trivia-fset
         trivia-ppcre
         trivia-quasiquote
         trivia-trivial;

  trivial-backtrace = callPackage (self: with self; lispify [ lift ] (pkgs.fetchFromGitLab {
    name = "trivial-backtrace-src";
    domain = "gitlab.common-lisp.net";
    owner = "trivial-backtrace";
    repo = "trivial-backtrace";
    rev = "version-1.1.0";
    sha256 = "sha256-RKNfjk5IrZSSOyc13VnR9GQ7mHj3IEWzizKmjVeHVu4=";
  })) {};

  trivial-cltl2 = callPackage (self: with self; lispDerivation {
    lispSystem = "trivial-cltl2";
    src = pkgs.fetchFromGitHub {
      name = "trivial-cltl2-src";
      owner = "Zulu-Inuoe";
      repo = "trivial-cltl2";
      rev = "2ada8722dc1d7bae1f49832a2ca26b25b90055d3";
      sha256 = "sha256-Q43ISShYRiNXVtFczzlpTxJ6upnNrR9CqEOY20DepXc=";
    };
  }) {};

  trivial-custom-debugger = callPackage (self: with self; lispDerivation {
    src = pkgs.fetchFromGitHub {
      name = "trivial-custom-debugger-src";
      owner = "phoe";
      repo = "trivial-custom-debugger";
      rev = "a560594a673bbcd88136af82086107ee5ff9ca81";
      sha256 = "sha256-0yPROdgl/Rv6oQ+o5hBrJafT/kGSkZFwcYHpdDUvMcc=";
    };
    lispSystem = "trivial-custom-debugger";
    lispCheckDependencies = [ parachute ];
  }) {};

  trivial-features = callPackage (self: with self; lispDerivation {
    src = pkgs.fetchFromGitHub {
      name = "trivial-features-src";
      owner = "trivial-features";
      repo = "trivial-features";
      rev = "v1.0";
      sha256 = "sha256-+Bp7YXl+Ys4/nkxNeE8D06uBwLJW7cJtpxF/+wNUWEs=";
    };
    lispSystem = "trivial-features";
    lispCheckDependencies = [ rt cffi cffi-grovel alexandria ];
  }) {};

  trivial-garbage = callPackage (self: with self; lispDerivation {
    src = pkgs.fetchFromGitHub {
      name = "trivial-garbage-src";
      owner = "trivial-garbage";
      repo = "trivial-garbage";
      rev = "v0.21";
      sha256 = "sha256-NnF43ZB6ag+0RSgB43HMrkCRbJjqI955UOye51iUQgQ=";
    };
    lispSystem = "trivial-garbage";
    lispCheckDependencies = [ rt ];
  }) {};

  trivial-gray-streams = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "trivial-gray-streams-src";
    owner = "trivial-gray-streams";
    repo = "trivial-gray-streams";
    rev = "2b3823edbc78a450db4891fd2b566ca0316a7876";
    sha256 = "sha256-9vN74Gum7ihKSrCygC3hRLczNd15nNCWn5r60jjHN8I=";
  })) {};

  trivial-indent = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "trivial-indent-src";
    repo = "trivial-indent";
    owner = "Shinmera";
    rev = "8d92e94756475d67fa1db2a9b5be77bc9c64d96c";
    sha256 = "sha256-G+YCIB3bKN4RotJUjT/6bnivSBalseFRhIlwsEm5EUk=";
  })) {};

  trivial-mimes = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "trivial-mimes-src";
    repo = "trivial-mimes";
    owner = "Shinmera";
    rev = "076655a2dc8d2563991c59c707c884d27fd27f1e";
    sha256 = "sha256-8KifeVu/uPm0iBmAY62PkqNNDpAQcA3qVTyA4/Q3Zzc=";
  })) {};

  trivial-sockets = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "trivial-sockets-src";
    owner = "usocket";
    repo = "trivial-sockets";
    rev = "v0.4";
    sha256 = "sha256-oNmzHkPgmyf4qrOM9n3H0ZXOdQ8fJ8HSVbjrO37pSXY=";
  })) {};

  trivial-types = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "trivial-types-src";
    owner = "m2ym";
    repo = "trivial-types";
    rev = "ee869f2b7504d8aa9a74403641a5b42b16f47d88";
    sha256 = "sha256-gQwbqW6730IPGPpVIO53e2X+Jg/u8IMPIcgu2la6jOg=";
  })) {};

  trivial-utf-8 = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitLab {
    name = "trivial-utf-8-src";
    domain = "gitlab.common-lisp.net";
    owner = "trivial-utf-8";
    repo = "trivial-utf-8";
    rev = "6ca9943588cbc61ad22a3c1ff81beb371e122394";
    sha256 = "sha256-Wg8g/aQHNyiQpMnrgK0Olyzi3RaoC0yDL97Ctb5f7z8=";
  })) {};

  trivial-with-current-source-form = callPackage (self: with self; lispify [ alexandria ] (pkgs.fetchFromGitHub {
    name = "trivial-with-current-source-form-src";
    owner = "scymtym";
    repo = "trivial-with-current-source-form";
    rev = "3898e09f8047ef89113df265574ae8de8afa31ac";
    sha256 = "sha256-IKJOyJYqGBx0b6Oomddvb+2K6q4W508s3xnplleMJIQ=";
  })) {};

  try = callPackage (self: with self; lispify [ alexandria closer-mop ieee-floats mgl-pax trivial-gray-streams ] (pkgs.fetchFromGitHub {
    owner = "melisgl";
    repo = "try";
    name = "try-src";
    rev = "a1fffad2ca328b3855f629b633ab1daaeec929c2";
    sha256 = "sha256-CUidhONmXu4yuNSDSBXflr72TO3tF9HS/z5y4kUUtQ0=";
  })) {};

  type-i = callPackage (self: with self; lispDerivation {
    lispSystem = "type-i";
    src = pkgs.fetchFromGitHub {
      name = "type-i-src";
      owner = "guicho271828";
      repo = "type-i";
      rev = "cab50bd996139674e13ec69a73c994cec969699f";
      sha256 = "sha256-oGD2/a2i4WsISC7NDZeSEGHH6TRMpaLmCMNImC0bpJk=";
    };
    lispDependencies = [
      alexandria
      introspect-environment
      trivia-trivial
      lisp-namespace
    ];
    lispCheckDependencies = [ fiveam ];
  }) {};

  unit-test = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "unit-test-src";
    owner = "hanshuebner";
    repo = "unit-test";
    rev = "266afaf4ac091fe0e8803bac2ae72d238144e735";
    sha256 = "sha256-SU7doHkJFZSaCTYr74RIsiU7MlLiFsHl2RNHU76eF4Y=";
  })) {};

  usocket = callPackage (self: with self; lispDerivation {
    lispSystem = "usocket";
    lispDependencies = [ split-sequence ];
    lispCheckDependencies = [ bordeaux-threads rt ];
    src = pkgs.fetchFromGitHub {
      name = "usocket-src";
      repo = "usocket";
      owner = "usocket";
      rev = "v0.8.5";
      sha256 = "sha256-anFwnv/E5WtuJO+WgdFcrvlM84EVdLcBPGu81Iirxd4=";
    };
  }) {};

  vom = callPackage (self: with self; lispify [ ] (pkgs.fetchFromGitHub {
    name = "vom-src";
    owner = "orthecreedence";
    repo = "vom";
    rev = "1aeafeb5b74c53741b79497e0ef4acf85c92ff24";
    sha256 = "sha256-nqVv41WDV5ncToM8UWchvWrp5rWCbNgzJV2ZI++dZhQ=";
  })) {};

  xsubseq = callPackage (self: with self; lispDerivation {
    src = pkgs.fetchFromGitHub {
      name = "xsubseq-src";
      repo = "xsubseq";
      owner = "fukamachi";
      rev = "5ce430b3da5cda3a73b9cf5cee4df2843034422b";
      sha256 = "sha256-/aaUy8um0lZpJXuBMrLO3azbfjSOR4n1cJRVcQFO5/c=";
    };
    lispSystem = "xsubseq";
    lispCheckDependencies = [ prove ];
  }) {};
})
