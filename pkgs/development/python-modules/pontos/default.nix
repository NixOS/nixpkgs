{ lib
, buildPythonPackage
, colorful
, fetchFromGitHub
, git
, httpx
, packaging
, poetry-core
, pytestCheckHook
, python-dateutil
, pythonOlder
, rich
, tomlkit
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pontos";
  version = "22.12.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-RzNc8clL6kqJuC0+KJLtgby/6Bn/CS3QLfx7Ug6TX3M=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    colorful
    httpx
    packaging
    python-dateutil
    rich
    typing-extensions
    tomlkit
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ] ++ httpx.optional-dependencies.http2;

  checkInputs = [
    git
    pytestCheckHook
  ];

  disabledTests = [
    "PrepareTestCase"
    # Signing fails
    "test_find_no_signing_key"
    "test_find_signing_key"
    "test_find_unreleased_information"
    # CLI test fails
    "test_missing_cmd"
    "test_update_file_changed"
    # Network access
    "test_fail_sign_on_upload_fail"
    "test_successfully_sign"
  ];

  pythonImportsCheck = [
    "pontos"
  ];

  meta = with lib; {
    description = "Collection of Python utilities, tools, classes and functions";
    homepage = "https://github.com/greenbone/pontos";
    changelog = "https://github.com/greenbone/pontos/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
