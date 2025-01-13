{
  lib,
  parseIpkgToOneLineFields,
  parseIpkgVersion,
  parseIpkg,
}:
let
  # Test 1
  test1_text = ''
    package micropack

    version = 0.0.1

    authors = "Stefan Höck"

    brief   = "Minimalistic installer for pack"

    langversion >= 0.6.0

    depends = base >= 0.6.0
            , elab-util

            , idris2
            , parser-toml

    main       = MicroPack
    executable = micropack
    modules = Pack.CmdLn
        , Pack.CmdLn.Completion
        , Pack.CmdLn.Types

        , Pack.Config

    sourcedir  = "src"
  '';

  # Test 1
  test2_text = ''
    package pack

    version = 0.0.1

    authors = "Stefan Höck"

    brief   = "A package manager for Idris2 with curated package collections"

    langversion >= 0.6.0

    -- script to run before building
    prebuild = "bash version.sh"

    postbuild = "bash restore.sh"

    depends = base >= 0.6.0
            , elab-util

            , idris2
            , parser-toml

    modules = Pack.CmdLn
            , Pack.CmdLn.Completion
            , Pack.CmdLn.Opts
            , Pack.CmdLn.Types

            , Pack.Config

    main       = Main

    executable = pack

    sourcedir  = "src"
  '';

  tests = {
    testMoreEq0_6_0 = {
      expr = parseIpkgVersion ">= 0.6.0";
      expected = {
        lowerInclusive = true;
        lowerBound = "0.6.0";
        upperInclusive = true;
        upperBound = "*";
      };
    };
    testLessEq0_6_0 = {
      expr = parseIpkgVersion "<= 0.6.0";
      expected = {
        lowerInclusive = true;
        lowerBound = "*";
        upperInclusive = true;
        upperBound = "0.6.0";
      };
    };
    testMore0_6_0_less0_5_0 = {
      expr = parseIpkgVersion "> 0.6.0 && < 0.5.0";
      expected = {
        lowerInclusive = false;
        lowerBound = "0.6.0";
        upperInclusive = false;
        upperBound = "0.5.0";
      };
    };
    testMore0_6_0 = {
      expr = parseIpkgVersion "> 0.6.0";
      expected = {
        lowerInclusive = false;
        lowerBound = "0.6.0";
        upperInclusive = true;
        upperBound = "*";
      };
    };
    testMore0_6_0_less0_7_0 = {
      expr = parseIpkgVersion "> 0.6.0 && < 0.7.0";
      expected = {
        lowerInclusive = false;
        lowerBound = "0.6.0";
        upperInclusive = false;
        upperBound = "0.7.0";
      };
    };
    testThrowsIfJustNumber = {
      expr = builtins.tryEval (parseIpkgVersion "0.6.0");
      expected = {
        "success" = false;
        "value" = false;
      };
    };
    testThrowsIfWrongOrder = {
      expr = builtins.tryEval (parseIpkgVersion "< 0.6.0 && > 0.7.0");
      expected = {
        "success" = false;
        "value" = false;
      };
    };
    testToLines = {
      expr = parseIpkgToOneLineFields test1_text;
      expected = [
        "package micropack"
        "version = 0.0.1"
        ''authors = "Stefan Höck"''
        ''brief   = "Minimalistic installer for pack"''
        "langversion >= 0.6.0"
        "depends = base >= 0.6.0, elab-util, idris2, parser-toml"
        "main       = MicroPack"
        "executable = micropack"
        "modules = Pack.CmdLn, Pack.CmdLn.Completion, Pack.CmdLn.Types, Pack.Config"
        ''sourcedir  = "src"''
      ];
    };
    # taken from idris2 --dump-ipkg-json ./micropack.ipkg
    testParsed = {
      expr = parseIpkg test1_text;
      expected = {
        name = "micropack";
        version = "0.0.1";
        authors = "Stefan Höck";
        brief = "Minimalistic installer for pack";
        langversion = {
          lowerInclusive = true;
          lowerBound = "0.6.0";
          upperInclusive = true;
          upperBound = "*";
        };
        depends = {
          base = {
            lowerInclusive = true;
            lowerBound = "0.6.0";
            upperInclusive = true;
            upperBound = "*";
          };
          elab-util = {
            lowerInclusive = true;
            lowerBound = "*";
            upperInclusive = true;
            upperBound = "*";
          };
          idris2 = {
            lowerInclusive = true;
            lowerBound = "*";
            upperInclusive = true;
            upperBound = "*";
          };
          parser-toml = {
            lowerInclusive = true;
            lowerBound = "*";
            upperInclusive = true;
            upperBound = "*";
          };
        };
        main = "MicroPack";
        executable = "micropack";
        modules = [
          "Pack.CmdLn"
          "Pack.CmdLn.Completion"
          "Pack.CmdLn.Types"
          "Pack.Config"
        ];
        sourcedir = "src";
      };
    };
    test2ToLines = {
      expr = parseIpkgToOneLineFields test2_text;
      expected = [
        "package pack"
        "version = 0.0.1"
        ''authors = "Stefan Höck"''
        ''brief   = "A package manager for Idris2 with curated package collections"''
        "langversion >= 0.6.0"
        ''prebuild = "bash version.sh"''
        ''postbuild = "bash restore.sh"''
        "depends = base >= 0.6.0, elab-util, idris2, parser-toml"
        "modules = Pack.CmdLn, Pack.CmdLn.Completion, Pack.CmdLn.Opts, Pack.CmdLn.Types, Pack.Config"
        "main       = Main"
        "executable = pack"
        ''sourcedir  = "src"''
      ];
    };
    test2Parsed = {
      expr = parseIpkg test2_text;
      expected = {
        name = "pack";
        depends = {
          base = {
            lowerInclusive = true;
            lowerBound = "0.6.0";
            upperInclusive = true;
            upperBound = "*";
          };
          elab-util = {
            lowerInclusive = true;
            lowerBound = "*";
            upperInclusive = true;
            upperBound = "*";
          };
          idris2 = {
            lowerInclusive = true;
            lowerBound = "*";
            upperInclusive = true;
            upperBound = "*";
          };
          parser-toml = {
            lowerInclusive = true;
            lowerBound = "*";
            upperInclusive = true;
            upperBound = "*";
          };
        };
        modules = [
          "Pack.CmdLn"
          "Pack.CmdLn.Completion"
          "Pack.CmdLn.Opts"
          "Pack.CmdLn.Types"
          "Pack.Config"
        ];
        version = "0.0.1";
        langversion = {
          lowerInclusive = true;
          lowerBound = "0.6.0";
          upperInclusive = true;
          upperBound = "*";
        };
        authors = "Stefan Höck";
        brief = "A package manager for Idris2 with curated package collections";
        main = "Main";
        executable = "pack";
        sourcedir = "src";
        prebuild = "bash version.sh";
        postbuild = "bash restore.sh";
      };
    };
  };

  #################################################################

  runTestsAll =
    tests:
    let
      testResults = lib.reverseList (lib.debug.runTests tests);
    in
    if testResults == [ ] then
      true
    else
      let
        errorMessage = lib.concatStringsSep "\n\n" (
          map (
            test:
            "Test: "
            + test.name
            + ''

              Expected: ''
            + builtins.toJSON test.expected
            + ''

              Actual  : ''
            + builtins.toJSON test.result
          ) testResults
        );
      in
      builtins.throw ''

        Tests failed.
        ${errorMessage}
      '';
  runTests = runTestsAll tests;
in
runTests
