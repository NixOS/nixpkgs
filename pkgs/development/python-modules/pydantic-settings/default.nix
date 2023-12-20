{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, hatchling
, pydantic
, python-dotenv
, pytestCheckHook
, pytest-examples
, pytest-mock
}:

buildPythonPackage rec {
  pname = "pydantic-settings";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-settings";
    rev = "v${version}";
    hash = "sha256-hU7u/AzaqCHKSUDHybsgXTW8IWi9hzBttPYDmMqdZbI=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pydantic
    python-dotenv
  ];

  pythonImportsCheck = [ "pydantic_settings" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-examples
    pytest-mock
  ];

  disabledTests = [
    # expected to fail
    "test_docs_examples[docs/index.md:212-246]"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Settings management using pydantic";
    homepage = "https://github.com/pydantic/pydantic-settings";
    license = licenses.mit;
    broken = lib.versionOlder pydantic.version "2.0.0";
    maintainers = with maintainers; [ ];
  };
}
