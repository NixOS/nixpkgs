{ lib
, stdenv
, callPackage
, resholve
, resholvePackage
, resholveScript
, resholveScriptBin
, shunit2
, coreutils
, gnused
, gnugrep
, findutils
, jq
, bash
, bats
, libressl
, openssl
, python27
, file
, gettext
, rSrc
, runDemo ? false
, binlore
, sqlite
, util-linux
, gawk
, rlwrap
, gnutar
, bc
}:

let
  default_packages = [ bash file findutils gettext ];
  parsed_packages = [ coreutils sqlite util-linux gnused gawk findutils rlwrap gnutar bc ];
in
rec {
  re_shunit2 = with shunit2;
    resholvePackage {
      inherit pname src version installPhase;
      solutions = {
        shunit = {
          interpreter = "none";
          scripts = [ "bin/shunit2" ];
          inputs = [ coreutils gnused gnugrep findutils ];
          # resholve's Nix API is analogous to the CLI flags
          # documented in 'man resholve'
          fake = {
            # "missing" functions shunit2 expects the user to declare
            function = [
              "oneTimeSetUp"
              "oneTimeTearDown"
              "setUp"
              "tearDown"
              "suite"
              "noexec"
            ];
            # shunit2 is both bash and zsh compatible, and in
            # some zsh-specific code it uses this non-bash builtin
            builtin = [ "setopt" ];
          };
          fix = {
            # stray absolute path; make it resolve from coreutils
            "/usr/bin/od" = true;
          };
          keep = {
            # variables invoked as commands; long-term goal is to
            # resolve the *variable*, but that is complexish, so
            # this is where we are...
            "$__SHUNIT_CMD_ECHO_ESC" = true;
            "$_SHUNIT_LINENO_" = true;
            "$SHUNIT_CMD_TPUT" = true;
          };
        };
      };
    };
  module1 = resholvePackage {
    pname = "testmod1";
    version = "unreleased";

    src = rSrc;
    setSourceRoot = "sourceRoot=$(echo */tests/nix/libressl)";

    installPhase = ''
      mkdir -p $out/{bin,submodule}
      install libressl.sh $out/bin/libressl.sh
      install submodule/helper.sh $out/submodule/helper.sh
    '';

    solutions = {
      libressl = {
        # submodule to demonstrate
        scripts = [ "bin/libressl.sh" "submodule/helper.sh" ];
        interpreter = "none";
        inputs = [ jq module2 libressl.bin ];
      };
    };

    is_it_okay_with_arbitrary_envs = "shonuff";
  };
  module2 = resholvePackage {
    pname = "testmod2";
    version = "unreleased";

    src = rSrc;
    setSourceRoot = "sourceRoot=$(echo */tests/nix/openssl)";

    installPhase = ''
      mkdir -p $out/bin
      install openssl.sh $out/bin/openssl.sh
      install profile $out/profile
    '';

    solutions = {
      openssl = {
        fix = {
          aliases = true;
        };
        scripts = [ "bin/openssl.sh" ];
        interpreter = "none";
        inputs = [ re_shunit2 openssl.bin ];
        execer = [
          /*
            This is the same verdict binlore will
            come up with. It's a no-op just to demo
            how to fiddle lore via the Nix API.
          */
          "cannot:${openssl.bin}/bin/openssl"
          # different verdict, but not used
          "can:${openssl.bin}/bin/c_rehash"
        ];
      };
      profile = {
        scripts = [ "profile" ];
        interpreter = "none";
        inputs = [ ];
      };
    };
  };
  module3 = resholvePackage {
    pname = "testmod3";
    version = "unreleased";

    src = rSrc;
    setSourceRoot = "sourceRoot=$(echo */tests/nix/future_perfect_tense)";

    installPhase = ''
      mkdir -p $out/bin
      install conjure.sh $out/bin/conjure.sh
    '';

    solutions = {
      conjure = {
        scripts = [ "bin/conjure.sh" ];
        interpreter = "${bash}/bin/bash";
        inputs = [ module1 ];
      };
    };
  };

  cli = stdenv.mkDerivation {
    name = "resholve-test";
    src = rSrc;
    installPhase = ''
      mkdir $out
      cp *.ansi $out/
    '';
    doCheck = true;
    buildInputs = [ resholve ];
    checkInputs = [ coreutils bats python27 ];
    # LOGLEVEL="DEBUG";

    # default path
    RESHOLVE_PATH = "${lib.makeBinPath default_packages}";
    # but separate packages for combining as needed
    PKG_FILE = "${lib.makeBinPath [ file ]}";
    PKG_FINDUTILS = "${lib.makeBinPath [ findutils ]}";
    PKG_GETTEXT = "${lib.makeBinPath [ gettext ]}";
    PKG_COREUTILS = "${lib.makeBinPath [ coreutils ]}";
    RESHOLVE_LORE = "${binlore.collect { drvs = default_packages ++ [ coreutils ] ++ parsed_packages; } }";
    PKG_PARSED = "${lib.makeBinPath parsed_packages}";

    # explicit interpreter for demo suite; maybe some better way...
    INTERP = "${bash}/bin/bash";

    checkPhase = ''
      patchShebangs .
      mkdir empty_lore
      touch empty_lore/{execers,wrappers}
      export EMPTY_LORE=$PWD/empty_lore
      printf "\033[33m============================= resholve test suite ===================================\033[0m\n" > test.ansi
      if ./test.sh &>> test.ansi; then
        cat test.ansi
      else
        cat test.ansi && exit 1
      fi
    '' + lib.optionalString runDemo ''
      printf "\033[33m============================= resholve demo ===================================\033[0m\n" > demo.ansi
      if ./demo &>> demo.ansi; then
        cat demo.ansi
      else
        cat demo.ansi && exit 1
      fi
    '';
  };

  # Caution: ci.nix asserts the equality of both of these w/ diff
  resholvedScript = resholveScript "resholved-script" {
    inputs = [ file ];
    interpreter = "${bash}/bin/bash";
  } ''
    echo "Hello"
    file .
  '';
  resholvedScriptBin = resholveScriptBin "resholved-script-bin" {
    inputs = [ file ];
    interpreter = "${bash}/bin/bash";
  } ''
    echo "Hello"
    file .
  '';
}
