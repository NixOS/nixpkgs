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
  version = "22.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-I+fnVRxkv8MjPOBElRZv2aigAOA0gGm5xoK+bFohfZA=";
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
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
