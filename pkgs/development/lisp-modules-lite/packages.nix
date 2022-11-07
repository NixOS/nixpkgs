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
  trimName = s.removeSuffix "-src";
  lispify = lispDependencies: src:
    lispDerivation ({
      inherit lispDependencies src;
      # Convention.
      lispSystem = src.lispSystem or trimName (src.pname or src.name);
    } // (
      optionalKeys [ "version" "CL_SOURCE_REGISTRY" ] src
    ) // (
      a.mapAttrs (_: trimName) (optionalKeys [ "name" "pname" ] src)
    ));

  # Get a source from debian package repository.
  fetchDebianPkg = { pname, version, ... }@args:
    let
      a = pkgs.lib.head (pkgs.lib.stringToCharacters pname);
      src = pkgs.fetchzip (args // {
        pname = "${pname}-src";
        url = "http://deb.debian.org/debian/pool/main/${a}/${pname}/${pname}_${version}.orig.tar.xz";
      });
    in
      pkgs.lib.sources.cleanSourceWith {
        filter = path: type:
          let
            relPath = pkgs.lib.removePrefix (toString src) (toString path);
          in
            relPath != "/debian" || type != "directory";
        inherit src;
      };

in
  rec {
    alexandria = lispify [ ] (pkgs.fetchFromGitLab {
      name = "alexandria-src";
      domain = "gitlab.common-lisp.net";
      owner = "alexandria";
      repo = "alexandria";
      rev = "v1.4";
      sha256 = "sha256-1Hzxt65dZvgOFIljjjlSGgKYkj+YBLwJCACi5DZsKmQ=";
    });

    anaphora = lispDerivation {
      lispSystem = "anaphora";
      lispCheckDependencies = [ rt ];
      src = pkgs.fetchFromGitHub {
        name = "anaphora-src";
        owner = "spwhitton";
        repo = "anaphora";
        rev = "0.9.8";
        sha256 = "sha256-CzApbUmdDmD+BWPcFGJN0rdZu991354EdTDPn8FSRbc=";
      };
    };

    array-utils = lispDerivation {
      lispSystem = "array-utils";
      lispCheckDependencies = [ parachute ];
      src = pkgs.fetchFromGitHub {
        name = "array-utils-src";
        owner = "Shinmera";
        repo = "array-utils";
        rev = "40cea8fc895add87d1dba9232da817750222b528";
        sha256 = "sha256-jcVm7dXVj69XrP8Ggl9bZWZ9Ultth/AFUkpANFVr9jQ=";
      };
    };

    arrow-macros = lispDerivation {
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
    };

    asdf-flv = lispify [ ] (pkgs.fetchFromGitHub {
      name = "net.didierverna.asdf-flv-src";
      owner = "didierverna";
      repo = "asdf-flv";
      rev = "version-2.1";
      sha256 = "sha256-5IFe7OZgQ9bgaqtTcvoyA5aJPy+KbtuKRA9ygbciCYA=";
    });

    assoc-utils = lispDerivation {
      lispSystem = "assoc-utils";
      src = pkgs.fetchFromGitHub {
        name = "assoc-utils-src";
        owner = "fukamachi";
        repo = "assoc-utils";
        rev = "483a22ef42995f84fac00d11fb27ace671480153";
        sha256 = "sha256-mncs6+mGNBoZea6jPtgjFxYPbFguUne8MepxTHgsC1c=";
      };
      lispCheckDependencies = [ prove ];
    };

    inherit (lispMultiDerivation {
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
          lispCheckDependencies = [ hu_dwim_stefil ];
        };
        babel-streams = {
          lispDependencies = [ alexandria babel trivial-gray-streams ];
          lispCheckDependencies = [ hu_dwim_stefil ];
        };
      };
    }) babel babel-streams;

    bordeaux-threads = let
      version = "v0.8.8";
    in
      lispDerivation {
        lispDependencies = [
          alexandria
          global-vars
          trivial-features
          trivial-garbage
        ];
        lispCheckDependencies = [ fiveam ];
        buildInputs = [ pkgs.libuv ];
        lispSystem = "bordeaux-threads";
        inherit version;
        src = pkgs.fetchFromGitHub {
          name = "bordeaux-threads-src";
          owner = "sionescu";
          repo = "bordeaux-threads";
          rev = version;
          sha256 = "sha256-5mauBDg13zJlYkbu5C30dCOIPBE95bVu2AiR8d0gJKY=";
        };
      };

    inherit (
      let version = "v0.24.1"; in lispMultiDerivation {
        name = "cffi";
        inherit version;
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
    ) cffi cffi-grovel;

    chipz = lispify [ ] (pkgs.fetchFromGitHub {
      name = "chipz-src";
      owner = "sharplispers";
      repo = "chipz";
      rev = "82a17d39c78d91f6ea63a03aca8f9aa6069a5e11";
      sha256 = "sha256-MJyhF/lPrkhTnyQdmN5enr2XERk/dG+avCoimaIQjtg=";
    });

    chunga = lispify [ trivial-gray-streams ] (pkgs.fetchFromGitHub {
      name = "chunga-src";
      owner = "edicl";
      repo = "chunga";
      rev = "v1.1.7";
      sha256 = "sha256-DfqbKCuK4oTh1qrKHdOCdWhcdUrT5YFSfUK4sbwd9ks=";
    });

    circular-streams = lispDerivation {
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
    };

    cl-annot = lispDerivation {
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
    };

    cl-ansi-text = lispDerivation {
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
    };

    inherit (
      let
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
        }
    ) cl-async cl-async-repl cl-async-ssl;

    cl-base64 = let
      version = "577683b18fd880b82274d99fc96a18a710e3987a";
    in
      lispDerivation {
        lispSystem = "cl-base64";
        inherit version;
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
      };

    cl-colors = lispDerivation {
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
    };

    cl-colors2 = let
      version = "cc37737fc70892ed97152842fafa086ad1b7beab";
    in
      lispDerivation {
        lispSystem = "cl-colors2";
        src = pkgs.fetchzip {
          pname = "cl-colors2-src";
          inherit version;
          url = "https://notabug.org/cage/cl-colors2/archive/${version}.tar.gz";
          sha256 = "sha256-GXq3Q6MjdS79EKks2ayojI+ZYh8hRVkd0TNkpjWF9zI=";
        };
        lispDependencies = [ alexandria cl-ppcre ];
        lispCheckDependencies = [ clunit2 ];
      };

    cl-cookie = lispDerivation {
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
    };

    cl-coveralls = lispDerivation {
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
    };

    cl-fad = lispDerivation {
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
    };

    cl-interpol = lispDerivation {
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
    };

    cl-isaac = lispDerivation {
      lispSystem = "cl-isaac";
      src = pkgs.fetchFromGitHub {
        name = "cl-isaac-src";
        owner = "thephoeron";
        repo = "cl-isaac";
        rev = "9cd88f39733be753facbf361cb0e08b9e42ff8d5";
        sha256 = "sha256-iV+7YkGPAA+e0SXODlSDAJIUUiL+pcj2ya7FHJGr4UU=";
      };
      lispCheckDependencies = [ prove ];
    };

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

    cl-plus-ssl = lispDerivation {
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
    };

    cl-ppcre = let
      version = "v2.1.1";
    in
      lispDerivation {
        lispSystem = "cl-ppcre";
        inherit version;
        src = pkgs.fetchFromGitHub {
          name = "cl-ppcre-src";
          owner = "edicl";
          repo = "cl-ppcre";
          rev = version;
          sha256 = "sha256-UffzJ2i4wpkShxAJZA8tIILUbBZzbWlseezj2JLImzc=";
        };
        lispCheckDependencies = [ flexi-streams ];
      };

    cl-speedy-queue = lispify [ ] (pkgs.fetchFromGitHub {
      name = "cl-speedy-queue-src";
      owner = "zkat";
      repo = "cl-speedy-queue";
      rev = "0425c7c62ad3b898a5ec58cd1b3e74f7d91eec4b";
      sha256 = "sha256-OGaqhBkHKNUwHY3FgnMbWGdsUfBn0QDTl2vTZPu28DM=";
    });

    inherit (lispMultiDerivation {
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
    }) cl-syntax cl-syntax-annot cl-syntax-interpol;

    cl-test-more = prove;

    cl-unicode = lispDerivation {
      lispSystem = "cl-unicode";
      src = pkgs.fetchFromGitHub {
        name = "cl-unicode-src";
        owner = "edicl";
        repo = "cl-unicode";
        rev = "v0.1.6";
        sha256 = "sha256-6kPg5c5k9KKRUZms0GRiLrQfBR0zgn7DJYc6TJMWfXo=";
      };
      lispDependencies = [ cl-ppcre flexi-streams ];
    };

    cl-who = lispDerivation {
      lispSystem = "cl-who";
      src = pkgs.fetchFromGitHub {
        name = "cl-who-src";
        owner = "edicl";
        repo = "cl-who";
        rev = "07dafe9b351c32326ce20b5804e798f10d4f273d";
        sha256 = "sha256-5T762W3qetAjXtHP77ko6YZR6w5bQ04XM6QZPELQu+U=";
      };
      lispCheckDependencies = [ flexi-streams ];
    };

    inherit (
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
      }
    ) clack clack-handler-hunchentoot clack-socket clack-test;

    # The official location for this source is
    # "https://www.common-lisp.net/project/cl-utilities/cl-utilities-latest.tar.gz"
    # but I’m not a huge fan of including a "latest.tar.gz" in a Nix
    # derivation. That being said: it hasn’t been changed since 2006, so maybe
    # that is a better resource.
    cl-utilities = lispDerivation {
      lispSystem = "cl-utilities";
      src = fetchDebianPkg {
        pname = "cl-utilities";
        version = "1.2.4";
        sha256 = "sha256-/CAF/qaLjd3t9P+0eSGoC18f3MJT1dB94VLUjnKbq7Y";
      };
    };

    closer-mop = lispify [ ] (pkgs.fetchFromGitHub {
      name = "closer-mop-src";
      repo = "closer-mop";
      owner = "pcostanza";
      rev = "60d05d6057bd2c8f37790989ffe2a2676c179f23";
      sha256 = "sha256-pOFP68j1P/vxilTNV7P2EqzDtk8qG4OrLuLszcIGdpU=";
    });

    clss = lispify [ array-utils plump ] (pkgs.fetchFromGitHub {
      name = "clss-src";
      repo = "clss";
      owner = "Shinmera";
      rev = "f62b849189c5d1be378f0bd3d403cda8d4fe310b";
      sha256 = "sha256-24XWonW5plv83h9Sule6q6nEFUAZOlxofwxadSFrY4A=";
    });

    clunit2 = let
      version = "200839e8e47e9212ded2d36520d84b9be681037c";
    in
      lispify [ ] (pkgs.fetchzip {
        pname = "clunit2-src";
        inherit version;
        url = "https://notabug.org/cage/clunit2/archive/${version}.tar.gz";
        sha256 = "sha256-5Pud/s5LywqrY+EjDG2iCtuuildTzfDmVYzqhnJ5iyQ=";
      });

    dexador = lispDerivation {
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
      ] ++ pkgs.lib.optional pkgs.hostPlatform.isWindows flexi-streams;
      lispCheckDependencies = [
        babel
        cl-cookie
        clack-test
        lack-request
        rove
      ];
    };

    # TODO: if clisp, then depend on cl-ppcre
    dissect = lispify [ ] (pkgs.fetchFromGitHub {
      name = "dissect-src";
      owner = "Shinmera";
      repo = "dissect";
      rev = "6c15c887a8d3db2ce83037ff31f8a0b528aa446b";
      sha256 = "sha256-px1DT8MRzeqEwsV/sJBJHrlsHrWEDQopfGzuHc+QqoE=";
    });

    documentation-utils = lispDerivation {
      lispSystem = "documentation-utils";
      src = pkgs.fetchFromGitHub {
        name = "documentation-utils-src";
        repo = "documentation-utils";
        owner = "Shinmera";
        rev = "98630dd5f7e36ae057fa09da3523f42ccb5d1f55";
        sha256 = "sha256-uMUyzymyS19ODiUjQbE/iJV7HFeVjB45gbnWqfGEGCU=";
      };
      lispDependencies = [ trivial-indent ];
    };

    drakma = lispDerivation {
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
    };

    eos = lispify [ ] (pkgs.fetchFromGitHub {
      name = "eos-src";
      owner = "adlai";
      repo = "Eos";
      rev = "b4413bccc4d142cbe1bf49516c3a0a22c9d99243";
      sha256 = "sha256-E9p5yKay3nyGWxmOeQTpfA51B2X+EUD+9yd1S+um1Kk=";
    });

    fast-http = lispDerivation {
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
    };

    fast-io = let
      deps = [
        alexandria
        static-vectors
        trivial-gray-streams
      ];
    in
      lispify deps (pkgs.fetchFromGitHub {
        name = "fast-io-src";
        owner = "rpav";
        repo = "fast-io";
        rev = "a4c5ad600425842e8b6233b1fa22610ffcd874c3";
        sha256 = "sha256-YBTROnJyB8w3H+GDhlHI+6n7XvnyoGN+8lDh9ZQXAHI=";
      });

    fare-mop = lispify [ closer-mop fare-utils ] (pkgs.fetchFromGitHub {
      name = "fare-mop-src";
      owner = "fare";
      repo = "fare-mop";
      rev = "538aa94590a0354f382eddd9238934763434af30";
      sha256 = "sha256-LGx/Te7RgHr9zuSRe2OXHa5WRbX8G6UsdKMkkQbSXVU=";
    });

    inherit (lispMultiDerivation {
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
          lispCheckDependencies = [ fare-quasiquote-extras hu_dwim_stefil optima ];
        };
        fare-quasiquote-extras = {
          lispDependencies = [ fare-quasiquote-readtable trivia-quasiquote ];
          # This needs a better solution. How do we deal with multi-system but
          # single-test-system derivs?
          lispCheckDependencies = [ hu_dwim_stefil ];
        };
        fare-quasiquote-readtable = {
          lispDependencies = [ fare-quasiquote named-readtables ];
          lispCheckDependencies = [ hu_dwim_stefil ];
        };
      };
    }) fare-quasiquote fare-quasiquote-extras fare-quasiquote-readtable;

    fare-utils = lispDerivation {
      lispSystem = "fare-utils";
      src = pkgs.fetchFromGitHub {
        name = "fare-utils-src";
        owner = "fare";
        repo = "fare-utils";
        rev = "1a4f345d7911b403d07a5f300e6006ce3efa4047";
        sha256 = "sha256-CTCYiXb5uy+QQBhkkDJEowax41rly677BSfLfpHX9vk=";
      };
      lispCheckDependencies = [ hu_dwim_stefil ];
    };

    fiveam = lispify [ alexandria asdf-flv trivial-backtrace ] (pkgs.fetchFromGitHub {
      name = "fiveam-src";
      owner = "lispci";
      repo = "fiveam";
      rev = "v1.4.2";
      sha256 = "sha256-ktwyRdDG3Z0KOnM0C8lbq7ZAZVqozTbwkiUsWuktsBI=";
    });

    flexi-streams = lispify [ trivial-gray-streams ] (pkgs.fetchFromGitHub {
      name = "flexi-streams-src";
      owner = "edicl";
      repo = "flexi-streams";
      rev = "v1.0.19";
      sha256 = "sha256-4GRKx0BrVtO6CjsSEal2/MzeXK+bel5J++w3mi2B9Gw=";
    });

    form-fiddle = lispDerivation {
      lispSystem = "form-fiddle";
      src = pkgs.fetchFromGitHub {
        name = "form-fiddle-src";
        repo = "form-fiddle";
        owner = "Shinmera";
        rev = "e0c23599dbb8cff3e83e012f3d86d0764188ad18";
        sha256 = "sha256-lsqBiHT6nYizomy8ZNe+Yq2btB8Jla0Bzd7dmpj9MRA=";
      };
      lispDependencies = [ documentation-utils ];
    };

    global-vars = lispify [ ] (pkgs.fetchFromGitHub {
      name = "global-vars-src";
      owner = "lmj";
      repo = "global-vars";
      rev = "c749f32c9b606a1457daa47d59630708ac0c266e";
      sha256 = "sha256-bXxeNNnFsGbgP/any8rR3xBvHE9Rb4foVfrdQRHroxo=";
    });

    http-body = lispDerivation {
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
    };

    hu_dwim_asdf = lispify [ ] (pkgs.fetchFromGitHub {
      name = "hu.dwim.asdf-src";
      owner = "hu-dwim";
      repo = "hu.dwim.asdf";
      rev = "2017-04-07";
      sha256 = "sha256-7U72ZSEtUZc0HSFhq6tRQP5RRxxzpe2NXaUND/UEbS0=";
    });

    hu_dwim_stefil = lispify [ alexandria hu_dwim_asdf ] (pkgs.fetchFromGitHub {
      name = "hu.dwim.stefil-src";
      owner = "hu-dwim";
      repo = "hu.dwim.stefil";
      rev = "2017-04-07";
      sha256 = "sha256-Ka3OO+cyafx0bcM9bdhZN2pHWjnVq116bU1mPS3ClSQ=";
    });

    hunchentoot = lispDerivation {
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
    };

    ieee-floats = lispDerivation {
      lispSystem = "ieee-floats";
      src = pkgs.fetchFromGitHub {
        name = "ieee-floats-src";
        owner = "marijnh";
        repo = "ieee-floats";
        rev = "9566ce8adfb299faef803d95736c780413a1373c";
        sha256 = "sha256-7fD+0p1MunjjZ3GJANypsufM2XYAWsSqk81+mXBv4mI=";
      };
      lispCheckDependencies = [ fiveam ];
    };

    inferior-shell = lispify [
      alexandria
      fare-utils
      fare-quasiquote-extras
      fare-mop
      trivia
      trivia-quasiquote
    ] (pkgs.fetchFromGitHub {
      name = "inferior-shell-src";
      owner = "fare";
      repo = "inferior-shell";
      rev = "15c2d04a7398db965ea1c3ba2d49efa7c851f2c2";
      sha256 = "sha256-lUj2tqRhmXWwgK3Qio1U+9vNhcJingN57USW+f8ZHQs=";
    });

    introspect-environment = lispDerivation {
      lispSystem = "introspect-environment";
      lispCheckDependencies = [ fiveam ];
      src = pkgs.fetchFromGitHub {
        name = "introspect-environment-src";
        owner = "Bike";
        repo = "introspect-environment";
        rev = "8fb20a1a33d29637a22943243d1482a20c32d6ae";
        sha256 = "sha256-Os0XnUtgq+zqpPT9UyLecXEHSVY+MsCTKIfUGLKViNw=";
      };
    };

    ironclad = lispDerivation {
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
    };

    iterate = lispify [ ] (pkgs.fetchFromGitLab {
      name = "iterate-src";
      domain = "gitlab.common-lisp.net";
      owner = "iterate";
      repo = "iterate";
      rev = "1.5.3";
      sha256 = "sha256-giEXCF+9q5fcCmE3Q6NDCq+rV6+qcglArJdf9q5D1FA=";
    });

    puri = lispDerivation {
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
    };

    jonathan = lispDerivation {
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
    };

    kmrcl = let
      version = "4a27407aad9deb607ffb8847630cde3d041ea25a";
    in
      lispDerivation {
        lispSystem = "kmrcl";
        inherit version;
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
      };

    inherit (
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

          lack-util = {
            lispDependencies =
              pkgs.lib.optional pkgs.hostPlatform.isWindows ironclad
              ++ pkgs.lib.optional (! pkgs.hostPlatform.isWindows) cl-isaac;
          };
        };
      }
    ) lack lack-middleware-backtrace lack-request lack-util;

    legion = lispDerivation {
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
    };

    let-plus = lispDerivation {
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
    };

    lift = lispify [ ] (pkgs.fetchFromGitHub {
      name = "lift-src";
      owner = "gwkkwg";
      repo = "lift";
      rev = "074601e7e18ebeb4fb9547eff70b52337ab18310";
      sha256 = "sha256-3WCwYgXQJ4mHyZrTtiKq2Bwiue1HJ/O3zYjj6QyxI5Q=";
    });

    lisp-namespace = lispDerivation {
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
    };

    local-time = lispDerivation {
      lispSystem = "local-time";
      src = pkgs.fetchFromGitHub {
        name = "local-time-src";
        rev = "40169fe26d9639f3d9560ec0255789bf00b30036";
        repo = "local-time";
        owner = "dlowe-net";
        sha256 = "sha256-TwrL74zNmYA+gw1c4DcvSET6cL/mzOIq1P/jWf8Yd7U=";
      };
      lispCheckDependencies = [ hu_dwim_stefil ];
    };

    log4cl = lispDerivation {
      lispSystem = "log4cl";
      src = pkgs.fetchFromGitHub {
        name = "log4cl-src";
        owner = "sharplispers";
        repo = "log4cl";
        rev = "75c4184fe3dbd7dec2ca590e5f0176de8ead7911";
        sha256 = "sha256-JUL1C029kOrlOO6RW3n82kDhMY3KNiwPsrvrOTjhU1Y=";
      };
      lispDependencies = [ bordeaux-threads ];
      lispCheckDependencies = [ hu_dwim_stefil ];
    };

    lquery = lispDerivation {
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
    };

    md5 = lispify [ flexi-streams ] (pkgs.fetchFromGitHub {
      name = "md5-src";
      owner = "pmai";
      repo = "md5";
      rev = "release-2.0.5";
      sha256 = "sha256-BY+ui/h01KrJ5VdsUfQBQvAaxJm00oo+An5YmM21QLw=";
    });

    mgl-pax = lispDerivation {
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
      lispCheckDependencies = [ try ];
    };

    named-readtables = lispDerivation {
      lispSystem = "named-readtables";
      src = pkgs.fetchFromGitHub {
        name = "named-readtables-src";
        repo = "named-readtables";
        owner = "melisgl";
        rev = "d5ff162ce02035ec7de1acc9721385f325e928c0";
        sha256 = "sha256-25eO3gnvP52mUvjdzHn/DoPwdwhbdXsn8FvV9bnvzz0=";
      };
      lispCheckDependencies = [ try ];
    };

    inherit (lispMultiDerivation {
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
    }) optima optima-ppcre;

    parachute = lispify [ documentation-utils form-fiddle trivial-custom-debugger ] (pkgs.fetchFromGitHub {
      owner = "Shinmera";
      repo = "parachute";
      name = "parachute-src";
      rev = "8bc3e1b5a1808341967aeb89516f9fab23cd1d9e";
      sha256 = "sha256-pZSyJ/CI80gZ/zX9k5XlfgCp6cewRT5ffxP3dHW49zI=";
    });

    plump = lispify [ array-utils documentation-utils ] (pkgs.fetchFromGitHub {
      owner = "Shinmera";
      repo = "plump";
      name = "plump-src";
      rev = "cf3633d812845c2f54bb559312e5b24b7fe73abc";
      sha256 = "sha256-McmssiqmYhNp+o3qlpCljw3anKvZU2LWJjQf0WnPxVY=";
    });

    proc-parse = lispDerivation {
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
    };

    prove = lispDerivation {
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
    };

    ptester = lispDerivation rec {
      lispSystem = "ptester";
      version = "20160829.gitfe69fde";
      src = fetchDebianPkg {
        inherit version;
        sha256 = "sha256-jjc7JP+T7jrbSsPU+RNhQrxOKYkQDfiJwyLbxg51FNA=";
        pname = "cl-ptester";
      };
    };

    pythonic-string-reader = lispify [ named-readtables ] (pkgs.fetchFromGitHub {
      name = "pythonic-string-reader-src";
      repo = "pythonic-string-reader";
      owner = "smithzvk";
      sha256 = "sha256-cuBcaLKD1lv8c2NELdJMg9Vnc0a/Tsa1GVB3xLHPsaw=";
      rev = "47a70ba1e32362e03dad6ef8e6f36180b560f86a";
    });

    quri = lispDerivation {
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
    };

    rfc2388 = lispify [ ] (pkgs.fetchFromGitLab {
      name = "rfc2388-src";
      domain = "gitlab.common-lisp.net";
      owner = "rfc2388";
      repo = "rfc2388";
      rev = "51bf93e91cb6c2d515c7674db19cc87d4550fd0b";
      sha256 = "sha256-RqFzdYyAEvJZKcSjSNXHog2KYxxFmyHupiX2DphUV4U=";
    });

    # For some reason none of these dependencies are specified in the .asd
    rove = lispify [
      bordeaux-threads
      dissect
      trivial-gray-streams
    ] (pkgs.fetchFromGitHub {
      name = "rove-src";
      owner = "fukamachi";
      repo = "rove";
      rev = "0.10.0";
      sha256 = "sha256-frJlBDdnoJjhKwqas/3zq414xQULCeN4XtzpgJL44ek=";
    });

    rt = let
      version = "a6a7503a0b47953bc7579c90f02a6dba1f6e4c5a";
    in
      lispDerivation {
        lispSystem = "rt";
        inherit version;
        src = pkgs.fetchzip {
          pname = "rt-src";
          inherit version;
          url = "http://git.kpe.io/?p=rt.git;a=snapshot;h=${version}";
          sha256 = "sha256-KxlltS8zCpuYX6Yp05eC2t/eWcTavD0XyOsp1XMWUY8=";
          # This is necessary because the auto generated filename for a gitweb
          # URL contains invalid characters.
          extension = "tar.gz";
        };
      };

    smart-buffer = lispDerivation {
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
    };

    split-sequence = lispDerivation {
      lispSystem = "split-sequence";
      lispCheckDependencies = [ fiveam ];
      src = pkgs.fetchFromGitHub {
        name = "split-sequence-src";
        owner = "sharplispers";
        repo = "split-sequence";
        rev = "89a10b4d697f03eb32ade3c373c4fd69800a841a";
        sha256 = "sha256-faF2EiQ+xXWHX9JlZ187xR2mWhdOYCpb4EZCPNoZ9uQ=";
      };
    };

    # N.B.: Soon won’t depend on cffi-grovel
    static-vectors = lispDerivation {
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
    };

    swank = lispDerivation {
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
    };

    inherit (lispMultiDerivation {
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
            trivia-ppcre
            trivia-quasiquote
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
    }) trivia trivia-ppcre trivia-quasiquote trivia-trivial;

    trivial-backtrace = lispify [ lift ] (pkgs.fetchFromGitLab {
      name = "trivial-backtrace-src";
      domain = "gitlab.common-lisp.net";
      owner = "trivial-backtrace";
      repo = "trivial-backtrace";
      rev = "version-1.1.0";
      sha256 = "sha256-RKNfjk5IrZSSOyc13VnR9GQ7mHj3IEWzizKmjVeHVu4=";
    });

    trivial-cltl2 = lispDerivation {
      lispSystem = "trivial-cltl2";
      src = pkgs.fetchFromGitHub {
        name = "trivial-cltl2-src";
        owner = "Zulu-Inuoe";
        repo = "trivial-cltl2";
        rev = "2ada8722dc1d7bae1f49832a2ca26b25b90055d3";
        sha256 = "sha256-Q43ISShYRiNXVtFczzlpTxJ6upnNrR9CqEOY20DepXc=";
      };
    };

    trivial-custom-debugger = lispDerivation {
      src = pkgs.fetchFromGitHub {
        name = "trivial-custom-debugger-src";
        owner = "phoe";
        repo = "trivial-custom-debugger";
        rev = "a560594a673bbcd88136af82086107ee5ff9ca81";
        sha256 = "sha256-0yPROdgl/Rv6oQ+o5hBrJafT/kGSkZFwcYHpdDUvMcc=";
      };
      lispSystem = "trivial-custom-debugger";
      lispCheckDependencies = [ parachute ];
    };

    trivial-features = lispDerivation {
      src = pkgs.fetchFromGitHub {
        name = "trivial-features-src";
        owner = "trivial-features";
        repo = "trivial-features";
        rev = "v1.0";
        sha256 = "sha256-+Bp7YXl+Ys4/nkxNeE8D06uBwLJW7cJtpxF/+wNUWEs=";
      };
      lispSystem = "trivial-features";
      lispCheckDependencies = [ rt cffi cffi-grovel alexandria ];
    };

    trivial-garbage = lispDerivation {
      src = pkgs.fetchFromGitHub {
        name = "trivial-garbage-src";
        owner = "trivial-garbage";
        repo = "trivial-garbage";
        rev = "v0.21";
        sha256 = "sha256-NnF43ZB6ag+0RSgB43HMrkCRbJjqI955UOye51iUQgQ=";
      };
      lispSystem = "trivial-garbage";
      lispCheckDependencies = [ rt ];
    };

    trivial-gray-streams = lispify [ ] (pkgs.fetchFromGitHub {
      name = "trivial-gray-streams-src";
      owner = "trivial-gray-streams";
      repo = "trivial-gray-streams";
      rev = "2b3823edbc78a450db4891fd2b566ca0316a7876";
      sha256 = "sha256-9vN74Gum7ihKSrCygC3hRLczNd15nNCWn5r60jjHN8I=";
    });

    trivial-indent = lispify [ ] (pkgs.fetchFromGitHub {
      name = "trivial-indent-src";
      repo = "trivial-indent";
      owner = "Shinmera";
      rev = "8d92e94756475d67fa1db2a9b5be77bc9c64d96c";
      sha256 = "sha256-G+YCIB3bKN4RotJUjT/6bnivSBalseFRhIlwsEm5EUk=";
    });

    trivial-mimes = lispify [ ] (pkgs.fetchFromGitHub {
      name = "trivial-mimes-src";
      repo = "trivial-mimes";
      owner = "Shinmera";
      rev = "076655a2dc8d2563991c59c707c884d27fd27f1e";
      sha256 = "sha256-8KifeVu/uPm0iBmAY62PkqNNDpAQcA3qVTyA4/Q3Zzc=";
    });

    trivial-sockets = lispify [ ] (pkgs.fetchFromGitHub {
      name = "trivial-sockets-src";
      owner = "usocket";
      repo = "trivial-sockets";
      rev = "v0.4";
      sha256 = "sha256-oNmzHkPgmyf4qrOM9n3H0ZXOdQ8fJ8HSVbjrO37pSXY=";
    });

    trivial-types = lispify [ ] (pkgs.fetchFromGitHub {
      name = "trivial-types-src";
      owner = "m2ym";
      repo = "trivial-types";
      rev = "ee869f2b7504d8aa9a74403641a5b42b16f47d88";
      sha256 = "sha256-gQwbqW6730IPGPpVIO53e2X+Jg/u8IMPIcgu2la6jOg=";
    });

    trivial-utf-8 = lispify [ ] (pkgs.fetchFromGitLab {
      name = "trivial-utf-8-src";
      domain = "gitlab.common-lisp.net";
      owner = "trivial-utf-8";
      repo = "trivial-utf-8";
      rev = "6ca9943588cbc61ad22a3c1ff81beb371e122394";
      sha256 = "sha256-Wg8g/aQHNyiQpMnrgK0Olyzi3RaoC0yDL97Ctb5f7z8=";
    });

    try = lispify [ alexandria closer-mop ieee-floats mgl-pax trivial-gray-streams ] (pkgs.fetchFromGitHub {
      owner = "melisgl";
      repo = "try";
      name = "try-src";
      rev = "a1fffad2ca328b3855f629b633ab1daaeec929c2";
      sha256 = "sha256-CUidhONmXu4yuNSDSBXflr72TO3tF9HS/z5y4kUUtQ0=";
    });

    type-i = lispDerivation {
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
    };

    unit-test = lispify [ ] (pkgs.fetchFromGitHub {
      name = "unit-test-src";
      owner = "hanshuebner";
      repo = "unit-test";
      rev = "266afaf4ac091fe0e8803bac2ae72d238144e735";
      sha256 = "sha256-SU7doHkJFZSaCTYr74RIsiU7MlLiFsHl2RNHU76eF4Y=";
    });

    usocket = lispDerivation {
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
    };

    vom = lispify [ ] (pkgs.fetchFromGitHub {
      name = "vom-src";
      owner = "orthecreedence";
      repo = "vom";
      rev = "1aeafeb5b74c53741b79497e0ef4acf85c92ff24";
      sha256 = "sha256-nqVv41WDV5ncToM8UWchvWrp5rWCbNgzJV2ZI++dZhQ=";
    });

    xsubseq = lispDerivation {
      src = pkgs.fetchFromGitHub {
        name = "xsubseq-src";
        repo = "xsubseq";
        owner = "fukamachi";
        rev = "5ce430b3da5cda3a73b9cf5cee4df2843034422b";
        sha256 = "sha256-/aaUy8um0lZpJXuBMrLO3azbfjSOR4n1cJRVcQFO5/c=";
      };
      lispSystem = "xsubseq";
      lispCheckDependencies = [ prove ];
    };
  }
