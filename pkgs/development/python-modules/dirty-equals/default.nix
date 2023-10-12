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

buildPythonPackage rec {
  pname = "dirty-equals";
  version = "0.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ShbkPGj1whOQ11bFLUSTfvVEVlvc3JUzRDICbBohgMM=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pytz
  ];

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
}
