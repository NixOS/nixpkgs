{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, python-gvm
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gvm-tools";
  version = "24.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4uYOhsnprYybt5EB/b4LW8/9cn0Nahc1lYQ+DwPNlOU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    python-gvm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Don't test sending
    "SendTargetTestCase"
  ] ++ lib.optionals (pythonAtLeast "3.10") [
    "HelpFormattingParserTestCase"
  ];

  pythonImportsCheck = [
    "gvmtools"
  ];

  meta = with lib; {
    description = "Collection of APIs that help with remote controlling a Greenbone Security Manager";
    homepage = "https://github.com/greenbone/gvm-tools";
    changelog = "https://github.com/greenbone/gvm-tools/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
