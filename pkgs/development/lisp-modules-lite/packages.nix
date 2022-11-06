{
  lispDerivation,
  lispMultiDerivation,
  optionalKeys,
  pkgs,
  a, b, l, t, s,
  ...
}:

let
  # Utility function that just adds some lisp dependencies to an existing
  # derivation.
  lispify = lispDependencies: src:
    lispDerivation ({
      inherit lispDependencies src;
      # Convention.
      lispSystem = src.lispSystem or src.pname or src.name;
    } // optionalKeys [ "pname" "name" "version" "CL_SOURCE_REGISTRY" ] src);

  # A convention for attrsets: elements starting with _ are “private”. This is
  # useful for declaring “helper values” in rec sets which can later be filtered
  # out.
  hidePrivateElements = a.filterAttrs (n: v: ! s.hasPrefix "_" n);
in
  hidePrivateElements rec {
    alexandria = lispify [ ] (pkgs.fetchFromGitLab {
      name = "alexandria";
      domain = "gitlab.common-lisp.net";
      owner = "alexandria";
      repo = "alexandria";
      rev = "v1.4";
      sha256 = "sha256-1Hzxt65dZvgOFIljjjlSGgKYkj+YBLwJCACi5DZsKmQ=";
    });

    arrow-macros = lispify [ alexandria ] (pkgs.fetchFromGitHub {
      name = "arrow-macros";
      owner = "hipeta";
      repo = "arrow-macros";
      rev = "0.2.7";
      sha256 = "sha256-r8zNLtBtk02xgz8oDM49sYs84SZya42GJaoHFnE/QZA=";
    });

    _babel = lispMultiDerivation {
      name = "babel";

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
        };
        babel-streams = {
          lispDependencies = [ alexandria babel trivial-gray-streams ];
        };
      };
    };

    inherit (_babel) babel babel-streams;

    bordeaux-threads = lispify [
      alexandria
      global-vars
      trivial-features
      trivial-garbage
    ] (pkgs.fetchFromGitHub {
      name = "bordeaux-threads";
      owner = "sionescu";
      repo = "bordeaux-threads";
      rev = "v0.8.8";
      sha256 = "sha256-5mauBDg13zJlYkbu5C30dCOIPBE95bVu2AiR8d0gJKY=";
    });

    _cffi = let version = "v0.24.1"; in lispMultiDerivation {
      name = "cffi";
      inherit version;
      src = pkgs.fetchFromGitHub {
        name = "cffi-src";
        owner = "cffi";
        repo = "cffi";
        rev = version;
        sha256 = "sha256-QzISoQ4JpLhnxnPlSgWYE0PbSionu+b7z2HR2EmNPp8=";
      };
      systems = {
        cffi = {
          lispDependencies = [ alexandria babel trivial-features ];
        };
        cffi-grovel = {
          lispDependencies = [ alexandria cffi trivial-features ];
          # cffi-grovel depends on cffi-toolchain. Just specifying it as an
          # exported system works because cffi-toolchain is specified in this
          # same source derivation.
          lispSystems = [ "cffi-grovel" "cffi-toolchain" ];
        };
      };
      # lisp-modules-new doesn’t specify this and somehow it works fine. Is
      # there an accidental transitive dependency, there? Or how is this
      # solved? Additionally, this only seems to be used by a pretty
      # incidental make call, because the only rule that uses GCC just happens
      # to be at the top, making it the default make target. Not sure if this
      # is the ideal way to “build” this package.
      # Note: Technically this will always be required because cffi-grovel
      # depends on cffi bare, but it’s a good litmus test for the system.
      buildInputs = systems: l.optional (b.elem "cffi" systems) pkgs.gcc;
    };

    inherit (_cffi) cffi cffi-grovel;

    _cl-async = let
      version = "909c691ec7a3bfe98bbec536ab55d7eac8990a81";
    in
      lispMultiDerivation {
        name = "cl-async";
        inherit version;

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
      };

    inherit (_cl-async) cl-async cl-async-repl cl-async-ssl;

    cl-libuv = let
      version = "ebe3e166d1b6608efdc575be55579a086356b3fc";
    in
      lispDerivation {
        lispDependencies = [ alexandria cffi cffi-grovel ];
        buildInputs = [ pkgs.libuv ];
        lispSystem = "cl-libuv";
        inherit version;
        src = pkgs.fetchFromGitHub {
          name = "cl-libuv-src";
          owner = "orthecreedence";
          repo = "cl-libuv";
          rev = version;
          sha256 = "sha256-sGN4sIM+yy7VXudzrU6jV/+DLEY12EOK69TXnh94rGU=";
        };
      };

    cl-ppcre = lispify [ ] (pkgs.fetchFromGitHub {
      name = "cl-ppcre";
      owner = "edicl";
      repo = "cl-ppcre";
      rev = "v2.1.1";
      sha256 = "sha256-UffzJ2i4wpkShxAJZA8tIILUbBZzbWlseezj2JLImzc=";
    });

    fast-io = let
      deps = [
        alexandria
        static-vectors
        trivial-gray-streams
      ];
    in
      lispify deps (pkgs.fetchFromGitHub {
        name = "fast-io";
        owner = "rpav";
        repo = "fast-io";
        rev = "a4c5ad600425842e8b6233b1fa22610ffcd874c3";
        sha256 = "sha256-YBTROnJyB8w3H+GDhlHI+6n7XvnyoGN+8lDh9ZQXAHI=";
      });

    global-vars = lispify [ ] (pkgs.fetchFromGitHub {
      name = "global-vars";
      owner = "lmj";
      repo = "global-vars";
      rev = "c749f32c9b606a1457daa47d59630708ac0c266e";
      sha256 = "sha256-bXxeNNnFsGbgP/any8rR3xBvHE9Rb4foVfrdQRHroxo=";
    });

    # N.B.: Soon won’t depend on cffi-grovel
    static-vectors = lispify [ alexandria cffi cffi-grovel ] (pkgs.fetchFromGitHub {
      name = "static-vectors";
      owner = "sionescu";
      repo = "static-vectors";
      rev = "v1.8.9";
      sha256 = "sha256-3BGtfPZH4qJKrZ6tJxf18QMbkn4qEofD198qSIFQOB0=";
    });

    trivial-features = lispify [ ] (pkgs.fetchFromGitHub {
      name = "trivial-features";
      owner = "trivial-features";
      repo = "trivial-features";
      rev = "v1.0";
      sha256 = "sha256-+Bp7YXl+Ys4/nkxNeE8D06uBwLJW7cJtpxF/+wNUWEs=";
    });

    trivial-garbage = lispify [ ] (pkgs.fetchFromGitHub {
      name = "trivial-garbage";
      owner = "trivial-garbage";
      repo = "trivial-garbage";
      rev = "v0.21";
      sha256 = "sha256-NnF43ZB6ag+0RSgB43HMrkCRbJjqI955UOye51iUQgQ=";
    });

    trivial-gray-streams = lispify [ ] (pkgs.fetchFromGitHub {
      name = "trivial-gray-streams";
      owner = "trivial-gray-streams";
      repo = "trivial-gray-streams";
      rev = "2b3823edbc78a450db4891fd2b566ca0316a7876";
      sha256 = "sha256-9vN74Gum7ihKSrCygC3hRLczNd15nNCWn5r60jjHN8I=";
    });

    vom = lispify [ ] (pkgs.fetchFromGitHub {
      name = "vom";
      owner = "orthecreedence";
      repo = "vom";
      rev = "1aeafeb5b74c53741b79497e0ef4acf85c92ff24";
      sha256 = "sha256-nqVv41WDV5ncToM8UWchvWrp5rWCbNgzJV2ZI++dZhQ=";
    });
  }

# TODO: More packages
