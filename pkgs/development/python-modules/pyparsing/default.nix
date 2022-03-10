{ buildPythonPackage
, fetchFromGitHub
, lib

# since this is a dependency of pytest, we need to avoid
# circular dependencies
, jinja2
, railroad-diagrams
}:

let
  pyparsing = buildPythonPackage rec {
    pname = "pyparsing";
    version = "3.0.6";

    src = fetchFromGitHub {
      owner = "pyparsing";
      repo = pname;
      rev = "pyparsing_${version}";
      sha256 = "0n89ky7rx5yg09ssji8liahnyxip08hz7syc2k4pmlgs4978181a";
    };

    # circular dependencies if enabled by default
    doCheck = false;
    checkInputs = [
      jinja2
      railroad-diagrams
    ];

    checkPhase = ''
      python -m unittest
    '';

    passthru.tests = {
      check = pyparsing.overridePythonAttrs (_: { doCheck = true; });
    };

    meta = with lib; {
      homepage = "https://github.com/pyparsing/pyparsing";
      description = "An alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions";
      license = licenses.mit;
      maintainers = with maintainers; [
        kamadorueda
      ];
    };
  };
in
  pyparsing
