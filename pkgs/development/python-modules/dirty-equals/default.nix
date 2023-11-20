{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pydantic
, pytest-examples
, pytestCheckHook
, pythonOlder
, pytz
}:

let
  dirty-equals = buildPythonPackage rec {
    pname = "dirty-equals";
    version = "0.7.1";
    format = "pyproject";

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "samuelcolvin";
      repo = pname;
      rev = "refs/tags/v${version}";
      hash = "sha256-SDTwtaH10ghESrI3gQEW6y/jMDR4+4JRQmvFgIxDQUc=";
    };

    nativeBuildInputs = [
      hatchling
    ];

    propagatedBuildInputs = [
      pytz
    ];

    doCheck = false;
    passthru.tests.pytest = dirty-equals.overrideAttrs { doCheck = true; };

    nativeCheckInputs = [
      pydantic
      pytest-examples
      pytestCheckHook
    ];

    pythonImportsCheck = [
      "dirty_equals"
    ];

    meta = with lib; {
      description = "Module for doing dirty (but extremely useful) things with equals";
      homepage = "https://github.com/samuelcolvin/dirty-equals";
      changelog = "https://github.com/samuelcolvin/dirty-equals/releases/tag/v${version}";
      license = with licenses; [ mit ];
      maintainers = with maintainers; [ fab ];
    };
  };
in dirty-equals
