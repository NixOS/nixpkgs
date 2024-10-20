{lib}: let
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

  startsWith = prefix: str: let
    prefixLength = builtins.stringLength prefix;
  in
    builtins.substring 0 prefixLength str == prefix;

  parseToLines = text: let
    splitLines = lib.splitString "\n" text;
    trimmedLines = map lib.trim splitLines;
    nonEmptyLines = builtins.filter (line: line != "") trimmedLines;
    nonEmptyLinesWithoutComments = builtins.filter (line: !(startsWith "--" line)) nonEmptyLines;

    foldLines =
      builtins.foldl'
      (
        acc: line: let
          isCommaLine = builtins.substring 0 1 line == ",";
          init = lib.sublist 0 lastIndex acc;
          lastIndex = builtins.length acc - 1;
          last =
            if lastIndex >= 0
            then builtins.elemAt acc lastIndex
            else "";
          newLastLine = last + line;
        in
          if isCommaLine
          then (init ++ [newLastLine])
          else acc ++ [line]
      )
      []
      nonEmptyLinesWithoutComments;
  in
    foldLines;

  # ">= 0.6.0" -> {"lowerInclusive": true,"lowerBound": "0.6.0","upperInclusive": true,"upperBound": "*"}
  # "<= 0.6.0" -> {"lowerInclusive": true,"lowerBound": "*","upperInclusive": true,"upperBound": "0.6.0"}
  # "0.6.0" -> throw error
  # "> 0.6.0 && < 0.5.0" -> {"lowerInclusive": false,"lowerBound": "0.6.0","upperInclusive": false,"upperBound": "0.5.0"}
  # "> 0.6.0" -> {"lowerInclusive": false,"lowerBound": "0.6.0","upperInclusive": true,"upperBound": "*"}
  # "> 0.6.0 && < 0.7.0" -> {"lowerInclusive": false,"lowerBound": "0.6.0","upperInclusive": false,"upperBound": "0.7.0"}
  parseVersion = value: let
    # split &&
    split = lib.splitString " && " value;
    # parse left part (required)
    # parse right part (optional)

    parseVersionPart = value: let
      split = lib.splitString " " value;
      operatorAndInclusive = builtins.elemAt split 0;

      operatorAndInclusiveAttrset =
        {
          ">=" = {
            operator = ">";
            inclusive = true;
          };
          "<=" = {
            operator = "<";
            inclusive = true;
          };
          "<" = {
            operator = "<";
            inclusive = false;
          };
          ">" = {
            operator = ">";
            inclusive = false;
          };
        }
        .${operatorAndInclusive}
        or (throw "Invalid version operator ${operatorAndInclusive} in version part ${value}");
    in
      {
        version = builtins.elemAt split 1;
      }
      // operatorAndInclusiveAttrset;

    left = parseVersionPart (builtins.elemAt split 0);
    right = parseVersionPart (builtins.elemAt split 1);
  in
    if value == null
    then throw "Version cannot be null"
    else if value == ""
    then throw "Version cannot be empty"
    else if builtins.length split == 1
    then
      {
        "<" = {
          lowerInclusive = true;
          lowerBound = "*";
          upperInclusive = left.inclusive;
          upperBound = left.version;
        };
        ">" = {
          lowerInclusive = left.inclusive;
          lowerBound = left.version;
          upperInclusive = true;
          upperBound = "*";
        };
      }
      .${left.operator}
      or (throw "Invalid version string ${value}")
    else if builtins.length split == 2
    then
      {
        "><" = {
          lowerInclusive = left.inclusive;
          lowerBound = left.version;
          upperInclusive = right.inclusive;
          upperBound = right.version;
        };
      }
      .${"${left.operator}${right.operator}"}
      or (throw "Invalid version string ${value}")
    else throw "Invalid version string ${value}";

  parseVersion_emptyIsInfinity = value:
    if value == ""
    then {
      lowerInclusive = true;
      lowerBound = "*";
      upperInclusive = true;
      upperBound = "*";
    }
    else parseVersion value;

  parseIpkg = text: let
    lines = parseToLines text;
    # split by first whitespace using regex, first element is the key
    dict =
      builtins.foldl'
      (acc: line: let
        splitByFirstWhitespaceIgnoreEqualSign = builtins.match "([[:alnum:]_]+)[[:space:]]+=?[[:space:]]*(.*)" line;
        key = builtins.elemAt splitByFirstWhitespaceIgnoreEqualSign 0;
        value = builtins.elemAt splitByFirstWhitespaceIgnoreEqualSign 1;

        keyParsed =
          if key == "package"
          then "name"
          else key;

        valueParsed =
          if key == "depends"
          then parseDependencies value
          else if key == "modules"
          then commaSeparatedToArray value
          else if key == "langversion"
          then parseVersion value
          else removeQuotes value;
      in
        acc // {${keyParsed} = valueParsed;})
      {}
      lines;

    removeQuotes = value:
      if builtins.substring 0 1 value == "\"" && builtins.substring (builtins.stringLength value - 1) 1 value == "\""
      then builtins.substring 1 (builtins.stringLength value - 2) value
      else value;

    # "foo, bar, baz" -> ["foo", "bar", "baz"]
    commaSeparatedToArray = value:
      builtins.map lib.trim (lib.splitString "," value);

    # "foo >= 0.6.0" -> { name = "foo"; value = ">= 0.6.0"; }
    dependecyToHashNameValue = stringValue: let
      split = lib.splitString " " stringValue;
      value = lib.concatStringsSep " " (lib.tail split);
      name = lib.head split;
    in
      lib.nameValuePair name value;

    # "foo >= 0.6.0, bar >= 0.7.0" => { foo = { lowerInclusive = true; lowerBound = "0.6.0"; ... }; bar = { lowerInclusive = true; lowerBound = "0.7.0"; ... } }
    parseDependencies = string: let
      nameValuesArray = builtins.map dependecyToHashNameValue (commaSeparatedToArray string);
    in
      builtins.mapAttrs (_name: value: parseVersion_emptyIsInfinity value) (builtins.listToAttrs nameValuesArray);
  in
    dict;

  importIpkg = path: parseIpkg (builtins.readFile path);

  #################################################################

  tests = {
    testMoreEq0_6_0 = {
      expr = parseVersion ">= 0.6.0";
      expected = {
        lowerInclusive = true;
        lowerBound = "0.6.0";
        upperInclusive = true;
        upperBound = "*";
      };
    };
    testLessEq0_6_0 = {
      expr = parseVersion "<= 0.6.0";
      expected = {
        lowerInclusive = true;
        lowerBound = "*";
        upperInclusive = true;
        upperBound = "0.6.0";
      };
    };
    testMore0_6_0_less0_5_0 = {
      expr = parseVersion "> 0.6.0 && < 0.5.0";
      expected = {
        lowerInclusive = false;
        lowerBound = "0.6.0";
        upperInclusive = false;
        upperBound = "0.5.0";
      };
    };
    testMore0_6_0 = {
      expr = parseVersion "> 0.6.0";
      expected = {
        lowerInclusive = false;
        lowerBound = "0.6.0";
        upperInclusive = true;
        upperBound = "*";
      };
    };
    testMore0_6_0_less0_7_0 = {
      expr = parseVersion "> 0.6.0 && < 0.7.0";
      expected = {
        lowerInclusive = false;
        lowerBound = "0.6.0";
        upperInclusive = false;
        upperBound = "0.7.0";
      };
    };
    testThrowsIfJustNumber = {
      expr = builtins.tryEval (parseVersion "0.6.0");
      expected = {
        "success" = false;
        "value" = false;
      };
    };
    testThrowsIfWrongOrder = {
      expr = builtins.tryEval (parseVersion "< 0.6.0 && > 0.7.0");
      expected = {
        "success" = false;
        "value" = false;
      };
    };
    testToLines = {
      expr = parseToLines test1_text;
      expected = [
        "package micropack"
        "version = 0.0.1"
        "authors = \"Stefan Höck\""
        "brief   = \"Minimalistic installer for pack\""
        "langversion >= 0.6.0"
        "depends = base >= 0.6.0, elab-util, idris2, parser-toml"
        "main       = MicroPack"
        "executable = micropack"
        "modules = Pack.CmdLn, Pack.CmdLn.Completion, Pack.CmdLn.Types, Pack.Config"
        "sourcedir  = \"src\""
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
      expr = parseToLines test2_text;
      expected = [
        "package pack"
        "version = 0.0.1"
        "authors = \"Stefan Höck\""
        "brief   = \"A package manager for Idris2 with curated package collections\""
        "langversion >= 0.6.0"
        "prebuild = \"bash version.sh\""
        "postbuild = \"bash restore.sh\""
        "depends = base >= 0.6.0, elab-util, idris2, parser-toml"
        "modules = Pack.CmdLn, Pack.CmdLn.Completion, Pack.CmdLn.Opts, Pack.CmdLn.Types, Pack.Config"
        "main       = Main"
        "executable = pack"
        "sourcedir  = \"src\""
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

  runTestsAll = tests: let
    testResults = lib.reverseList (lib.debug.runTests tests);
  in
    if testResults == []
    then true
    else let
      errorMessage = lib.concatStringsSep "\n\n" (map (
          test:
            "Test: " + test.name + "\nExpected: " + builtins.toJSON test.expected + "\nActual  : " + builtins.toJSON test.result
        )
        testResults);
    in
      builtins.throw "\nTests failed.\n${errorMessage}\n";
in
  assert (runTestsAll tests); {
    inherit parseIpkg importIpkg;
  }
