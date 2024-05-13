{
  lib,
  fetchFromGitHub,
  git,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "vunnel";
  version = "0.22.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anchore";
    repo = "vunnel";
    rev = "refs/tags/v${version}";
    hash = "sha256-g/dlo2M7TJRYAbk3HtGQlMUZhORxt+OsDgP8W7rf+NE=";
  };

  pythonRelaxDeps = [
    "ijson"
    "sqlalchemy"
  ];

  nativeBuildInputs = with python3.pkgs; [ pythonRelaxDepsHook ];

  build-system = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python3.pkgs; [
    click
    colorlog
    cvss
    defusedxml
    ijson
    importlib-metadata
    iso8601
    lxml
    mashumaro
    mergedeep
    orjson
    pytest-snapshot
    python-dateutil
    pyyaml
    requests
    sqlalchemy
    xsdata
    xxhash
    zstandard
  ];

  nativeCheckInputs =
    [ git ]
    ++ (with python3.pkgs; [
      jsonschema
      pytest-mock
      pytest-unordered
      pytestCheckHook
    ]);

  pythonImportsCheck = [ "vunnel" ];

  disabledTests = [
    # Compare output
    "test_status"
    # TypeError
    "test_parser"
  ];

  meta = with lib; {
    description = "Tool for collecting vulnerability data from various sources";
    homepage = "https://github.com/anchore/vunnel";
    changelog = "https://github.com/anchore/vunnel/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "vunnel";
  };
}
