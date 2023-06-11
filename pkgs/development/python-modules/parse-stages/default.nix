{ buildPythonPackage
, fetchFromGitLab
, lib
, pytestCheckHook
, hatchling
, hatch-requirements-txt
, pyparsing
}:

let
  parse-stages = buildPythonPackage rec {
    pname = "parse-stages";
    version = "0.1.4";
    format = "pyproject";

    src = fetchFromGitLab {
      owner = "ppentchev";
      repo = "parse-stages";
      rev = "release/${version}";
      sha256 = "03pcPOLkk2gJdLe5RZzfIK2jzFtyrSB51r3CE5DdSuc=";
    };

    meta = with lib; {
      homepage = "https://devel.ringlet.net/devel/parse-stages/";
      description = "Parse a mini-language for selecting objects by tag or name";
      license = licenses.bsd2;
      maintainers = with maintainers; [ ppentchev ];
    };

    propagatedBuildInputs = [
      hatchling
      hatch-requirements-txt
      pyparsing
    ];

    checkInputs = [
      pytestCheckHook
    ];
    pythonImportsCheck = [ "parse_stages" ];
  };
in
parse-stages
