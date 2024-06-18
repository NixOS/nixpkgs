{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pytest-examples,
  pytestCheckHook,
  pythonOlder,
  pytz,
}:

let
  dirty-equals = buildPythonPackage rec {
    pname = "dirty-equals";
    version = "0.7.1-post0";
    format = "pyproject";

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "samuelcolvin";
      repo = pname;
      rev = "refs/tags/v${version}";
      hash = "sha256-U6DNluthDgxzh6IOaKrN/JhX4u+ztY/jVp9IKh0iP34=";
    };

    nativeBuildInputs = [ hatchling ];

    propagatedBuildInputs = [ pytz ];

    doCheck = false;
    passthru.tests.pytest = dirty-equals.overrideAttrs { doCheck = true; };

    nativeCheckInputs = [
      pydantic
      pytest-examples
      pytestCheckHook
    ];

    pythonImportsCheck = [ "dirty_equals" ];

    meta = with lib; {
      description = "Module for doing dirty (but extremely useful) things with equals";
      homepage = "https://github.com/samuelcolvin/dirty-equals";
      changelog = "https://github.com/samuelcolvin/dirty-equals/releases/tag/v${version}";
      license = with licenses; [ mit ];
      maintainers = with maintainers; [ fab ];
    };
  };
in
dirty-equals
